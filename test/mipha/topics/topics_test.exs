defmodule Mipha.TopicsTest do
  use Mipha.DataCase

  alias Mipha.Topics

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
      type: "some type",
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
      type: "some updated type",
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
      type: nil,
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
      assert Topics.get_topic!(topic.id) == topic
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
      assert topic.type == "some type"
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
      assert topic.type == "some updated type"
      assert topic.user_id == 43
      assert topic.visit_count == 43
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, @invalid_attrs)
      assert topic == Topics.get_topic!(topic.id)
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
end
