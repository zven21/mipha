defmodule MiphaWeb.PageControllerTest do
  use MiphaWeb.ConnCase

  test "GET /", %{conn: conn} do
    t1 = insert(:topic)
    t2 = insert(:topic)

    conn = get(conn, topic_path(conn, :index))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
    assert conn.resp_body =~ t2.title
  end
end
