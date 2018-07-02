defmodule MiphaWeb.SessionController do
  use MiphaWeb, :controller

  alias Mipha.Accounts
  alias Mipha.Accounts.User

  def new(conn, _params) do
    changeset = User.register_changeset(%User{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn |> ok_login(user)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  defp ok_login(conn, user) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user.id)
    |> redirect(to: "/")
  end
end
