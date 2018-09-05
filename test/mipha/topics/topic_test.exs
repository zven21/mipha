defmodule Mipha.Topics.TopicTest do
  use Mipha.DataCase

  alias Mipha.Topics.Topic

  @valid_attrs %{title: "elixir mipha", body: "elixir mipha body", node_id: 1, user_id: 1}
  @invalid_attrs %{title: nil, body: "elixir mipha body", node_id: nil}

  describe "changeset" do
    test "with valid attrs" do
      changeset = Topic.changeset(%Topic{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attrs" do
      changeset = Topic.changeset(%Topic{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
