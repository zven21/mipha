defmodule MiphaWeb.UserController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  def show(conn, %{"name" => name}) do
    user = Accounts.get_user_by_username(name)
    render conn, :show, user: user
  end
end
