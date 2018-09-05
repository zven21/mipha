defmodule Mipha.Topics.NodeTest do
  use Mipha.DataCase

  alias Mipha.Topics.Node

  @valid_attrs %{name: "elixir mipha"}
  @invalid_attrs %{name: nil}

  describe "changeset" do
    test "with valid attrs" do
      changeset = Node.changeset(%Node{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attrs" do
      changeset = Node.changeset(%Node{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
