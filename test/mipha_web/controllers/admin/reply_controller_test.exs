defmodule MiphaWeb.Admin.ReplyControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "lists all replies on index", %{conn: conn} do
    r1 = insert(:reply)
    r2 = insert(:reply)

    conn = get(conn, admin_reply_path(conn, :index))
    assert conn.status == 200
    assert conn.resp_body =~ r1.content
    assert conn.resp_body =~ r2.content
  end
end
