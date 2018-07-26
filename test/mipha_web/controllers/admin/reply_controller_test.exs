defmodule MiphaWeb.Admin.ReplyControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Replies

  @create_attrs %{
    content: "some content",
    parent_id: 42,
    topic_id: 42,
    user_id: 42
  }

  def fixture(:reply) do
    {:ok, reply} = Replies.create_reply(@create_attrs)
    reply
  end

  describe "index" do
    test "lists all repies", %{conn: conn} do
      conn = get conn, admin_reply_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end

  describe "delete reply" do
    setup [:create_reply]

    test "deletes chosen reply", %{conn: conn, reply: reply} do
      conn = delete conn, admin_reply_path(conn, :delete, reply)
      assert redirected_to(conn) == admin_reply_path(conn, :index)
    end
  end

  defp create_reply(_) do
    reply = fixture(:reply)
    {:ok, reply: reply}
  end
end
