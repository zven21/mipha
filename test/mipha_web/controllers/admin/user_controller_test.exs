defmodule MiphaWeb.Admin.UserControllerTest do
  use MiphaWeb.ConnCase

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
