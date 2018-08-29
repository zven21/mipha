defmodule MiphaWeb.Admin.UserControllerTest do
  use MiphaWeb.ConnCase

  # @valid_attrs %{email: "some email", username: "some one"}
  # @invalid_attrs %{email: "", username: "zven"}

  @tag :as_admin
  test "lists all users on index", %{conn: conn} do
    u1 = insert(:user)
    u2 = insert(:user)

    conn = get(conn, admin_user_path(conn, :index))
    assert conn.status == 200
    assert conn.resp_body =~ u1.username
    assert conn.resp_body =~ u2.username
  end
end
