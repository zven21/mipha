defmodule MiphaWeb.Admin.ReplyControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Replies

  @create_attrs %{content: "some content", parent_id: 42, topic_id: 42, user_id: 42}
  @update_attrs %{content: "some updated content", parent_id: 43, topic_id: 43, user_id: 43}
  @invalid_attrs %{content: nil, parent_id: nil, topic_id: nil, user_id: nil}

  def fixture(:reply) do
    {:ok, reply} = Replies.create_reply(@create_attrs)
    reply
  end

  describe "index" do
    test "lists all repies", %{conn: conn} do
      conn = get conn, admin_reply_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Repies"
    end
  end

  describe "new reply" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_reply_path(conn, :new)
      assert html_response(conn, 200) =~ "New Reply"
    end
  end

  describe "create reply" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_reply_path(conn, :create), reply: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_reply_path(conn, :show, id)

      conn = get conn, admin_reply_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Reply"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_reply_path(conn, :create), reply: @invalid_attrs
      assert html_response(conn, 200) =~ "New Reply"
    end
  end

  describe "edit reply" do
    setup [:create_reply]

    test "renders form for editing chosen reply", %{conn: conn, reply: reply} do
      conn = get conn, admin_reply_path(conn, :edit, reply)
      assert html_response(conn, 200) =~ "Edit Reply"
    end
  end

  describe "update reply" do
    setup [:create_reply]

    test "redirects when data is valid", %{conn: conn, reply: reply} do
      conn = put conn, admin_reply_path(conn, :update, reply), reply: @update_attrs
      assert redirected_to(conn) == admin_reply_path(conn, :show, reply)

      conn = get conn, admin_reply_path(conn, :show, reply)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, reply: reply} do
      conn = put conn, admin_reply_path(conn, :update, reply), reply: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Reply"
    end
  end

  describe "delete reply" do
    setup [:create_reply]

    test "deletes chosen reply", %{conn: conn, reply: reply} do
      conn = delete conn, admin_reply_path(conn, :delete, reply)
      assert redirected_to(conn) == admin_reply_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_reply_path(conn, :show, reply)
      end
    end
  end

  defp create_reply(_) do
    reply = fixture(:reply)
    {:ok, reply: reply}
  end
end
