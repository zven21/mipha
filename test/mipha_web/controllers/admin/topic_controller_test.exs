defmodule MiphaWeb.Admin.TopicControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Topics

  @create_attrs %{
    body: "some body",
    closed_at: ~N[2010-04-17 14:00:00.000000],
    last_reply_id: 42,
    last_reply_user_id: 42,
    node_id: 42,
    replied_at: ~N[2010-04-17 14:00:00.000000],
    reply_count: 42,
    suggested_at: ~N[2010-04-17 14:00:00.000000],
    title: "some title",
    user_id: 42,
    visit_count: 42
  }
  @update_attrs %{
    body: "some updated body",
    closed_at: ~N[2011-05-18 15:01:01.000000],
    last_reply_id: 43,
    last_reply_user_id: 43,
    node_id: 43,
    replied_at: ~N[2011-05-18 15:01:01.000000],
    reply_count: 43,
    suggested_at: ~N[2011-05-18 15:01:01.000000],
    title: "some updated title",
    user_id: 43,
    visit_count: 43
  }
  @invalid_attrs %{
    body: nil,
    closed_at: nil,
    last_reply_id: nil,
    last_reply_user_id: nil,
    node_id: nil,
    replied_at: nil,
    reply_count: nil,
    suggested_at: nil,
    title: nil,
    user_id: nil,
    visit_count: nil
  }

  def fixture(:topic) do
    {:ok, topic} = Topics.create_topic(@create_attrs)
    topic
  end

  describe "index" do
    test "lists all topics", %{conn: conn} do
      conn = get conn, admin_topic_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Topics"
    end
  end

  describe "new topic" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_topic_path(conn, :new)
      assert html_response(conn, 200) =~ "New Topic"
    end
  end

  describe "create topic" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_topic_path(conn, :create), topic: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_topic_path(conn, :show, id)

      conn = get conn, admin_topic_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Topic"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_topic_path(conn, :create), topic: @invalid_attrs
      assert html_response(conn, 200) =~ "New Topic"
    end
  end

  describe "edit topic" do
    setup [:create_topic]

    test "renders form for editing chosen topic", %{conn: conn, topic: topic} do
      conn = get conn, admin_topic_path(conn, :edit, topic)
      assert html_response(conn, 200) =~ "Edit Topic"
    end
  end

  describe "update topic" do
    setup [:create_topic]

    test "redirects when data is valid", %{conn: conn, topic: topic} do
      conn = put conn, admin_topic_path(conn, :update, topic), topic: @update_attrs
      assert redirected_to(conn) == admin_topic_path(conn, :show, topic)

      conn = get conn, admin_topic_path(conn, :show, topic)
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, topic: topic} do
      conn = put conn, admin_topic_path(conn, :update, topic), topic: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Topic"
    end
  end

  describe "delete topic" do
    setup [:create_topic]

    test "deletes chosen topic", %{conn: conn, topic: topic} do
      conn = delete conn, admin_topic_path(conn, :delete, topic)
      assert redirected_to(conn) == admin_topic_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_topic_path(conn, :show, topic)
      end
    end
  end

  defp create_topic(_) do
    topic = fixture(:topic)
    {:ok, topic: topic}
  end
end
