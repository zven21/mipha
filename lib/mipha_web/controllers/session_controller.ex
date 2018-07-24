defmodule MiphaWeb.SessionController do
  use MiphaWeb, :controller

  alias Mipha.{
    Accounts,
    Mailer,
    Token
  }

  alias Mipha.Accounts.User
  alias MiphaWeb.Email
  alias Captcha

  def new(conn, _params) do
    changeset = User.register_changeset(%User{}, %{})
    render conn, :new, changeset: changeset
  end

  def rucaptcha(conn, _) do
    {:ok, text, img_binary} = Captcha.get()

    conn
    |> put_session(:rucaptcha, text)
    |> put_resp_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
    |> put_resp_header("Pragma", "no-cache")
    |> put_resp_content_type("image/gif")
    |> send_resp(200, img_binary)
  end

  def create(conn, %{"user" => user_params}) do
    # 确定验证码是否正确。
    # is_true_captcha =
    #   conn
    #   |> get_session(:rucaptcha)
    #   |> String.equivalent?(captcha)

    # unless is_true_captcha do
    #   changeset = User.register_changeset(%User{}, user_params)

    #   conn
    #   |> put_flash(:danger, "验证码错误，请重新输入")
    #   |> render(:new, changeset: changeset)
    # end

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        sent_welcome_email(user)
        conn
        |> ok_login(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "注册失败，请重新注册一下。")
        |> render(:new, changeset: changeset)
    end
  end

  defp sent_welcome_email(user) do
    user
    |> Token.generate_token()
    |> Email.welcome(user)
    |> Mailer.deliver_later()
  end

  defp ok_login(conn, user) do
    conn
    |> put_flash(:info, "注册成功。如果遇到 BUG，欢迎提 Issue :-)")
    |> put_session(:current_user, user.id)
    |> redirect(to: "/")
  end
end
