defmodule MiphaWeb.Admin.UserControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Accounts

  @create_attrs %{
    avatar: "some avatar",
    bio: "some bio",
    email: "some email",
    github_handle: "some github_handle",
    is_admin: true,
    password_hash: "some password_hash",
    username: "some username",
    website: "some website"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, admin_user_path(conn, :delete, user)
      assert redirected_to(conn) == admin_user_path(conn, :index)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
