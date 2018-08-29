defmodule MiphaWeb.TopicControllerTest do
  use MiphaWeb.ConnCase

  test "getting the topis index", %{conn: conn} do
    t1 = insert(:topic)
    t2 = insert(:topic)

    conn = get(conn, topic_path(conn, :index))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
    assert conn.resp_body =~ t2.title
  end

  test "getting a topic show page", %{conn: conn} do
    t = insert(:topic)
    conn = get(conn, topic_path(conn, :show, t.id))
    assert html_response(conn, 200) =~ t.title
  end

  # test "getting a topic page that doesn't exist", %{conn: conn} do
  #   assert_raise Ecto.NoResultsError, fn ->
  #     get conn, topic_path(conn, :show, "bad-id")
  #   end
  # end
end
