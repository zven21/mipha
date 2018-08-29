defmodule MiphaWeb.Admin.TopicControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "lists all topics on index", %{conn: conn} do
    t1 = insert(:topic)
    t2 = insert(:topic)

    conn = get(conn, admin_topic_path(conn, :index))
    assert conn.status == 200
    assert conn.resp_body =~ t1.title
    assert conn.resp_body =~ t2.title
  end
end
