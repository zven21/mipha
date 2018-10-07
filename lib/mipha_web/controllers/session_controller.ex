defmodule MiphaWeb.SessionController do
  use MiphaWeb, :controller

  alias Mipha.{Accounts, Mailer, Token}
  alias MiphaWeb.Email

  plug :authorized_user

  def new(conn, _params) do
    changeset = Accounts.user_register_changeset()
    render(conn, :new, changeset: changeset)
  end

  def excaptcha(conn, _) do
    {:ok, text, img_binary} = Captcha.get(50_000)

    conn
    |> put_session(:excaptcha, text)
    |> put_resp_header("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate")
    |> put_resp_header("Pragma", "no-cache")
    |> put_resp_content_type("image/gif")
    |> send_resp(200, img_binary)
  end

  def create(conn, %{"user" => user_params, "_excaptcha" => captcha}) do
    # Validation captcha.
    is_true_captcha =
      conn
      |> get_session(:excaptcha)
      |> String.equivalent?(captcha)

    unless is_true_captcha do
      changeset = Accounts.user_register_changeset(user_params)

      conn
      |> put_flash(:danger, gettext("captcha error, pls input again."))
      |> render(:new, changeset: changeset)
    end

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        sent_welcome_email(user)

        conn
        |> ok_login(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, gettext("Register failed. pls try again."))
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
    |> put_flash(:info, gettext("Registered successfully"))
    |> put_session(:current_user, user.id)
    |> redirect(to: "/")
  end

  # if user login,can't reach this controller.
  defp authorized_user(conn, _) do
    if current_user(conn) do
      conn
      |> put_flash(:danger, "You has logged in")
      |> redirect(to: "/")
    else
      conn
    end
  end
end
