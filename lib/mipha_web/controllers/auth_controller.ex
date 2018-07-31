defmodule MiphaWeb.AuthController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  plug :authorized_user when action not in ~w(delete)a

  def login(conn, _params) do
    changeset = Accounts.user_login_changeset()
    render(conn, :login, changeset: changeset)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "退出成功。")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  alias Ueberauth.Strategy.Helpers

  def request(conn, %{"provider" => "identity"}) do
    changeset = Accounts.user_register_changeset()
    render(conn, :request, callback_url: Helpers.callback_url(conn), changeset: changeset)
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:danger, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    case auth.provider do
      :identity ->
        attrs = %{
          login: params["user"]["login"],
          password: params["user"]["password"]
        }
        case Accounts.authenticate(attrs) do
          {:ok, user} ->
            conn |> ok_login(user)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:danger, "Login unsuccessful")
            |> render(:login, callback_url: Helpers.callback_url(conn), changeset: changeset)

          {:error, reason} ->
            changeset = Accounts.user_login_changeset()
            conn
            |> put_flash(:danger, reason)
            |> render(:login, callback_url: Helpers.callback_url(conn), changeset: changeset)
        end
      :github ->
        with %{name: name, nickname: nickname, email: email} <- auth.info do
          case Accounts.login_or_register_from_github(%{
                  name: name,
                  nickname: nickname,
                  email: email
                }) do
            {:ok, user} ->
              conn
              |> ok_login(user)

            {:error, reason} ->
              conn
              |> put_flash(:error, reason)
              |> redirect(to: "/")
          end
        end
    end
  end

  defp ok_login(conn, user) do
    conn
    |> put_flash(:info, "登录成功。")
    |> put_session(:current_user, user.id)
    |> redirect(to: "/")
  end

  # if user login,can't reach this controller.
  defp authorized_user(conn, _) do
    if current_user(conn) do
      conn
      |> put_flash(:danger, "你已登录")
      |> redirect(to: "/")
    else
      conn
    end
  end
end
