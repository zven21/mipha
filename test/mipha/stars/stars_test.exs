defmodule Mipha.StarsTest do
  use Mipha.DataCase

  alias Mipha.Stars

  describe "stars" do
    alias Mipha.Stars.Star

    @valid_attrs %{reply_id: 42, topic_id: 42, user_id: 42}
    @update_attrs %{reply_id: 43, topic_id: 43, user_id: 43}
    @invalid_attrs %{reply_id: nil, topic_id: nil, user_id: nil}

    def star_fixture(attrs \\ %{}) do
      {:ok, star} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stars.create_star()

      star
    end

    test "list_stars/0 returns all stars" do
      star = star_fixture()
      assert Stars.list_stars() == [star]
    end

    test "get_star!/1 returns the star with given id" do
      star = star_fixture()
      assert Stars.get_star!(star.id) == star
    end

    test "create_star/1 with valid data creates a star" do
      assert {:ok, %Star{} = star} = Stars.create_star(@valid_attrs)
      assert star.reply_id == 42
      assert star.topic_id == 42
      assert star.user_id == 42
    end

    test "create_star/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stars.create_star(@invalid_attrs)
    end

    test "update_star/2 with valid data updates the star" do
      star = star_fixture()
      assert {:ok, star} = Stars.update_star(star, @update_attrs)
      assert %Star{} = star
      assert star.reply_id == 43
      assert star.topic_id == 43
      assert star.user_id == 43
    end

    test "update_star/2 with invalid data returns error changeset" do
      star = star_fixture()
      assert {:error, %Ecto.Changeset{}} = Stars.update_star(star, @invalid_attrs)
      assert star == Stars.get_star!(star.id)
    end

    test "delete_star/1 deletes the star" do
      star = star_fixture()
      assert {:ok, %Star{}} = Stars.delete_star(star)
      assert_raise Ecto.NoResultsError, fn -> Stars.get_star!(star.id) end
    end

    test "change_star/1 returns a star changeset" do
      star = star_fixture()
      assert %Ecto.Changeset{} = Stars.change_star(star)
    end
  end
end
