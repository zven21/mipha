defmodule Mipha.AccountsTest do
  use Mipha.DataCase

  alias Mipha.Accounts

  describe "users" do
    alias Mipha.Accounts.User

    @valid_attrs %{
      avatar: "some avatar",
      bio: "some bio",
      email: "some email",
      github_handle: "some github_handle",
      is_admin: true,
      password_hash: "some password_hash",
      username: "some username",
      website: "some website"
    }
    @update_attrs %{
      avatar: "some updated avatar",
      bio: "some updated bio",
      email: "some updated email",
      github_handle: "some updated github_handle",
      is_admin: false,
      password_hash: "some updated password_hash",
      username: "some updated username",
      website: "some updated website"
    }
    @invalid_attrs %{
      avatar: nil,
      bio: nil,
      email: nil,
      github_handle: nil,
      is_admin: nil,
      password_hash: nil,
      username: nil,
      website: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar == "some avatar"
      assert user.bio == "some bio"
      assert user.email == "some email"
      assert user.github_handle == "some github_handle"
      assert user.is_admin == true
      assert user.password_hash == "some password_hash"
      assert user.username == "some username"
      assert user.website == "some website"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar == "some updated avatar"
      assert user.bio == "some updated bio"
      assert user.email == "some updated email"
      assert user.github_handle == "some updated github_handle"
      assert user.is_admin == false
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
      assert user.website == "some updated website"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "locations" do
    alias Mipha.Accounts.Location

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_location()

      location
    end

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Accounts.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Accounts.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = Accounts.create_location(@valid_attrs)
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, location} = Accounts.update_location(location, @update_attrs)
      assert %Location{} = location
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_location(location, @invalid_attrs)
      assert location == Accounts.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Accounts.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Accounts.change_location(location)
    end
  end
end
