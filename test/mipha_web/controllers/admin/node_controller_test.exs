defmodule MiphaWeb.Admin.NodeControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "lists all nodes on index", %{conn: conn} do
    n1 = insert(:node)
    n2 = insert(:node)

    conn = get(conn, admin_node_path(conn, :index))
    assert conn.status == 200
    assert conn.resp_body =~ n1.name
    assert conn.resp_body =~ n2.name
  end
end
