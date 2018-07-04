defmodule Mipha.FollowsTest do
  use Mipha.DataCase

  alias Mipha.Follows

  describe "follows" do
    alias Mipha.Follows.Follow

    @valid_attrs %{follower_id: 42, user_id: 42}
    @update_attrs %{follower_id: 43, user_id: 43}
    @invalid_attrs %{follower_id: nil, user_id: nil}

    def follow_fixture(attrs \\ %{}) do
      {:ok, follow} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Follows.create_follow()

      follow
    end

    test "list_follows/0 returns all follows" do
      follow = follow_fixture()
      assert Follows.list_follows() == [follow]
    end

    test "get_follow!/1 returns the follow with given id" do
      follow = follow_fixture()
      assert Follows.get_follow!(follow.id) == follow
    end

    test "create_follow/1 with valid data creates a follow" do
      assert {:ok, %Follow{} = follow} = Follows.create_follow(@valid_attrs)
      assert follow.follower_id == 42
      assert follow.user_id == 42
    end

    test "create_follow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Follows.create_follow(@invalid_attrs)
    end

    test "update_follow/2 with valid data updates the follow" do
      follow = follow_fixture()
      assert {:ok, follow} = Follows.update_follow(follow, @update_attrs)
      assert %Follow{} = follow
      assert follow.follower_id == 43
      assert follow.user_id == 43
    end

    test "update_follow/2 with invalid data returns error changeset" do
      follow = follow_fixture()
      assert {:error, %Ecto.Changeset{}} = Follows.update_follow(follow, @invalid_attrs)
      assert follow == Follows.get_follow!(follow.id)
    end

    test "delete_follow/1 deletes the follow" do
      follow = follow_fixture()
      assert {:ok, %Follow{}} = Follows.delete_follow(follow)
      assert_raise Ecto.NoResultsError, fn -> Follows.get_follow!(follow.id) end
    end

    test "change_follow/1 returns a follow changeset" do
      follow = follow_fixture()
      assert %Ecto.Changeset{} = Follows.change_follow(follow)
    end
  end
end
