defmodule Mipha.CollectionsTest do
  use Mipha.DataCase

  alias Mipha.Collections

  describe "collections" do
    alias Mipha.Collections.Collection

    @valid_attrs %{topic_id: 42, user_id: 42}
    @update_attrs %{topic_id: 43, user_id: 43}
    @invalid_attrs %{topic_id: nil, user_id: nil}

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Collections.create_collection()

      collection
    end

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Collections.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Collections.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      assert {:ok, %Collection{} = collection} = Collections.create_collection(@valid_attrs)
      assert collection.topic_id == 42
      assert collection.user_id == 42
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collections.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      assert {:ok, collection} = Collections.update_collection(collection, @update_attrs)
      assert %Collection{} = collection
      assert collection.topic_id == 43
      assert collection.user_id == 43
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Collections.update_collection(collection, @invalid_attrs)
      assert collection == Collections.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Collections.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Collections.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Collections.change_collection(collection)
    end
  end
end
