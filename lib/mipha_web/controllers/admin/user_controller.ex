defmodule MiphaWeb.Admin.UserController do
  use MiphaWeb, :controller

  alias Mipha.Accounts
  alias Mipha.Accounts.User
  alias Mipha.Ransack

  def index(conn, params) do
    result = Ransack.ransack(User, params)
    render conn, :index, users: result.datas, paginate: result.paginate
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end
end
