defmodule MiphaWeb.AuthController do
  use MiphaWeb, :controller
  alias Mipha.Accounts
  alias Mipha.Accounts.User

  def login(conn, _params) do
    changeset = User.login_changeset(%User{}, %{})
    render(conn, :login, changeset: changeset)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  alias Ueberauth.Strategy.Helpers

  def request(conn, %{"provider" => "identity"}) do
    changeset = User.register_changeset(%User{}, %{})
    render(conn, :request, callback_url: Helpers.callback_url(conn), changeset: changeset)
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"user" => user_params}) do
    case auth.provider do
      :identity ->
        case Accounts.authenticate(%{login: user_params["login"], password: user_params["password"]}) do
          {:ok, user} ->
            conn |> ok_login(user)
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:error, "Login unsuccessful")
            |> render(:login, callback_url: Helpers.callback_url(conn), changeset: changeset)
          {:error, reason} ->
            changeset = User.login_changeset(%User{}, %{})
            conn
            |> put_flash(:error, reason)
            |> render(:login, callback_url: Helpers.callback_url(conn), changeset: changeset)
        end
      _ ->
        IO.puts("ignore")
        # ignore
    end
  end

  defp ok_login(conn, user) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user.id)
    |> redirect(to: "/")
  end
end
