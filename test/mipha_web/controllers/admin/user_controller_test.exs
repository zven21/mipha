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
  @update_attrs %{
    avatar: "some updated avatar",
    bio: "some updated bio",
    email: "some updated email",
    github_handle: "some updated github_handle",
    is_admin: false,
    password_hash: "some updated password_hash",
    username: "some updated username",
    website: "some updated website"
  }
  @invalid_attrs %{
    avatar: nil,
    bio: nil,
    email: nil,
    github_handle: nil,
    is_admin: nil,
    password_hash: nil,
    username: nil,
    website: nil
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_user_path(conn, :create), user: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_user_path(conn, :show, id)

      conn = get conn, admin_user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, admin_user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, admin_user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == admin_user_path(conn, :show, user)

      conn = get conn, admin_user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated avatar"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, admin_user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, admin_user_path(conn, :delete, user)
      assert redirected_to(conn) == admin_user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
