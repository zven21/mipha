defmodule Mipha.RepliesTest do
  use Mipha.DataCase

  alias Mipha.Replies

  describe "repies" do
    alias Mipha.Replies.Reply

    @valid_attrs %{content: "some content", parent_id: 42, topic_id: 42, user_id: 42}
    @update_attrs %{content: "some updated content", parent_id: 43, topic_id: 43, user_id: 43}
    @invalid_attrs %{content: nil, parent_id: nil, topic_id: nil, user_id: nil}

    def reply_fixture(attrs \\ %{}) do
      {:ok, reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Replies.create_reply()

      reply
    end

    test "list_repies/0 returns all repies" do
      reply = reply_fixture()
      assert Replies.list_repies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Replies.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      assert {:ok, %Reply{} = reply} = Replies.create_reply(@valid_attrs)
      assert reply.content == "some content"
      assert reply.parent_id == 42
      assert reply.topic_id == 42
      assert reply.user_id == 42
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Replies.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      assert {:ok, reply} = Replies.update_reply(reply, @update_attrs)
      assert %Reply{} = reply
      assert reply.content == "some updated content"
      assert reply.parent_id == 43
      assert reply.topic_id == 43
      assert reply.user_id == 43
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Replies.update_reply(reply, @invalid_attrs)
      assert reply == Replies.get_reply!(reply.id)
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Replies.change_reply(reply)
    end
  end
end
