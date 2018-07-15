defmodule Mipha.TopicsTest do
  use Mipha.DataCase

  alias Mipha.{Topics, Repo}

  describe "topics" do
    alias Mipha.Topics.Topic

    @valid_attrs %{
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

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Topics.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Topics.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Topics.get_topic!(topic.id) == (topic |> Repo.preload([:node, :user, :last_reply_user, [replies: [:user, [parent: :user]]]]))
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Topics.create_topic(@valid_attrs)
      assert topic.body == "some body"
      assert topic.closed_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.last_reply_id == 42
      assert topic.last_reply_user_id == 42
      assert topic.node_id == 42
      assert topic.replied_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.reply_count == 42
      assert topic.suggested_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.title == "some title"
      assert topic.user_id == 42
      assert topic.visit_count == 42
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Topics.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.body == "some updated body"
      assert topic.closed_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.last_reply_id == 43
      assert topic.last_reply_user_id == 43
      assert topic.node_id == 43
      assert topic.replied_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.reply_count == 43
      assert topic.suggested_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.title == "some updated title"
      assert topic.user_id == 43
      assert topic.visit_count == 43
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, @invalid_attrs)
      assert (topic |> Repo.preload([:node, :user, :last_reply_user, [replies: [:user, [parent: :user]]]])) == Topics.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Topics.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic(topic)
    end
  end

  describe "nodes" do
    alias Mipha.Topics.Node

    @valid_attrs %{name: "some name", parent_id: 42, position: 42, summary: "some summary"}
    @update_attrs %{name: "some updated name", parent_id: 43, position: 43, summary: "some updated summary"}
    @invalid_attrs %{name: nil, parent_id: nil, position: nil, summary: nil}

    def node_fixture(attrs \\ %{}) do
      {:ok, node} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Topics.create_node()

      node
    end

    test "list_nodes/0 returns all nodes" do
      node = node_fixture()
      assert Topics.list_nodes() == [node]
    end

    test "get_node!/1 returns the node with given id" do
      node = node_fixture()
      assert Topics.get_node!(node.id) == node
    end

    test "create_node/1 with valid data creates a node" do
      assert {:ok, %Node{} = node} = Topics.create_node(@valid_attrs)
      assert node.name == "some name"
      assert node.parent_id == 42
      assert node.position == 42
      assert node.summary == "some summary"
    end

    test "create_node/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_node(@invalid_attrs)
    end

    test "update_node/2 with valid data updates the node" do
      node = node_fixture()
      assert {:ok, node} = Topics.update_node(node, @update_attrs)
      assert %Node{} = node
      assert node.name == "some updated name"
      assert node.parent_id == 43
      assert node.position == 43
      assert node.summary == "some updated summary"
    end

    test "update_node/2 with invalid data returns error changeset" do
      node = node_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_node(node, @invalid_attrs)
      assert node == Topics.get_node!(node.id)
    end

    test "delete_node/1 deletes the node" do
      node = node_fixture()
      assert {:ok, %Node{}} = Topics.delete_node(node)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_node!(node.id) end
    end

    test "change_node/1 returns a node changeset" do
      node = node_fixture()
      assert %Ecto.Changeset{} = Topics.change_node(node)
    end
  end
end
