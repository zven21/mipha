defmodule Mipha.AccountsTest do
  use Mipha.DataCase

  alias Mipha.{Accounts, Repo}

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
      assert Accounts.get_location!(location.id) == (location |> Repo.preload([:users]))
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
      assert (location |> Repo.preload([:users])) == Accounts.get_location!(location.id)
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

  describe "companies" do
    alias Mipha.Accounts.Company

    @valid_attrs %{location_id: 42, name: "some name"}
    @update_attrs %{location_id: 43, name: "some updated name"}
    @invalid_attrs %{location_id: nil, name: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Accounts.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Accounts.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Accounts.create_company(@valid_attrs)
      assert company.location_id == 42
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, company} = Accounts.update_company(company, @update_attrs)
      assert %Company{} = company
      assert company.location_id == 43
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_company(company, @invalid_attrs)
      assert company == Accounts.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Accounts.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Accounts.change_company(company)
    end
  end

  describe "teams" do
    alias Mipha.Accounts.Team

    @valid_attrs %{
      avatar: "some avatar",
      github_handle: "some github_handle",
      name: "some name",
      owner_id: 42,
      slug: "some slug",
      summary: "some summary"
    }
    @update_attrs %{
      avatar: "some updated avatar",
      github_handle: "some updated github_handle",
      name: "some updated name",
      slug: "some slug",
      owner_id: 43,
      summary: "some updated summary"
    }
    @invalid_attrs %{
      avatar: nil,
      github_handle: nil,
      slug: nil,
      name: nil,
      owner_id: nil,
      summary: nil
    }

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Accounts.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Accounts.get_team!(team.id) == (team |> Repo.preload([:team_users, :owner]))
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Accounts.create_team(@valid_attrs)
      assert team.avatar == "some avatar"
      assert team.github_handle == "some github_handle"
      assert team.name == "some name"
      assert team.owner_id == 42
      assert team.summary == "some summary"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, team} = Accounts.update_team(team, @update_attrs)
      assert %Team{} = team
      assert team.avatar == "some updated avatar"
      assert team.github_handle == "some updated github_handle"
      assert team.name == "some updated name"
      assert team.owner_id == 43
      assert team.summary == "some updated summary"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_team(team, @invalid_attrs)
      assert (team |> Repo.preload([:team_users, :owner])) == Accounts.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Accounts.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Accounts.change_team(team)
    end
  end

  describe "users_teams" do
    alias Mipha.Accounts.UserTeam

    @valid_attrs %{
      team_id: 42,
      user_id: 42,
      role: "owner",
      status: "pending"
    }
    @update_attrs %{
      team_id: 43,
      user_id: 43
    }
    @invalid_attrs %{
      team_id: nil,
      user_id: nil,
      role: nil,
      status: nil
    }

    def user_team_fixture(attrs \\ %{}) do
      {:ok, user_team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_team()

      user_team
    end

    test "list_users_teams/0 returns all users_teams" do
      user_team = user_team_fixture()
      assert Accounts.list_users_teams() == [user_team]
    end

    test "get_user_team!/1 returns the user_team with given id" do
      user_team = user_team_fixture()
      assert Accounts.get_user_team!(user_team.id) == user_team
    end

    test "create_user_team/1 with valid data creates a user_team" do
      assert {:ok, %UserTeam{} = user_team} = Accounts.create_user_team(@valid_attrs)
      assert user_team.team_id == 42
      assert user_team.user_id == 42
    end

    test "create_user_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_team(@invalid_attrs)
    end

    test "update_user_team/2 with valid data updates the user_team" do
      user_team = user_team_fixture()
      assert {:ok, user_team} = Accounts.update_user_team(user_team, @update_attrs)
      assert %UserTeam{} = user_team
      assert user_team.team_id == 43
      assert user_team.user_id == 43
    end

    test "update_user_team/2 with invalid data returns error changeset" do
      user_team = user_team_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_team(user_team, @invalid_attrs)
      assert user_team == Accounts.get_user_team!(user_team.id)
    end

    test "delete_user_team/1 deletes the user_team" do
      user_team = user_team_fixture()
      assert {:ok, %UserTeam{}} = Accounts.delete_user_team(user_team)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_team!(user_team.id) end
    end

    test "change_user_team/1 returns a user_team changeset" do
      user_team = user_team_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_team(user_team)
    end
  end
end
