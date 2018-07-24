defmodule Mipha.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Comeonin.Bcrypt
  alias HTTPoison
  alias Mipha.Repo
  alias Mipha.Accounts.{User, Team}
  alias Mipha.Utils.Store

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Register user.

  ## Example

      iex> register_user(%{username: "user", email:"user@minpha.com", password: "123123123"})
      {:ok, %User{}}

      iex> register_user(%{username: "user", email:"user@minpha", password: "123123123"})
      {:error, %Ecto.Changeset{}}

  """
  @spec register_user(map()) :: {:ok, User.t()} | {:error, %Ecto.Changeset{}}
  def register_user(attrs) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Authenticate user login.

  ## Examples

      iex> authenticate(%{login: "zven", password: "123123123"})
      {:ok, %User{}}

      iex> authenticate(%{login: "zven", password: "123123123"})
      {:error, "Incorrect login credentials"}

  """
  @spec authenticate(map()) :: {:ok, User.t()} | {:error, String.t()}
  def authenticate(attrs) do
    user = get_user_by_email(attrs.login) || get_user_by_username(attrs.login)

    case check_user_password(user, attrs.password) do
      true -> {:ok, user}
      _    -> {:error, "Failed auth."}
    end
  end

  @doc """
  Gets a user by given clauses.
  """
  @spec get_user_by(Keyword.t(), Keyword.t()) :: User.t() | nil
  def get_user_by(clauses, opts \\ []) do
    User
    |> preload([:location, :company, :teams])
    |> Repo.get_by(clauses)
  end

  @doc """
  Gets a user by its username.

  ## Examples

      iex> get_user_by_username("user123")
      %User{}

      iex> get_user_by_username("user456")
      nil

  """
  @spec get_user_by_username(String.t(), Keyword.t()) :: User.t() | nil
  def get_user_by_username(username, opts \\ []),
    do: get_user_by([username: username], opts)

  @doc """
  Gets a user by its email.

  ## Examples

      iex> get_user_by_email("user123@mipha.com")
      %User{}

      iex> get_user_by_email("user456@mipha.com")
      nil

  """
  @spec get_user_by_email(String.t(), Keyword.t()) :: User.t() | nil
  def get_user_by_email(email, opts \\ []),
    do: get_user_by([email: email], opts)

  defp check_user_password(user, password) do
    case user do
      nil -> false
      _   -> !is_nil(user.password_hash) && Bcrypt.checkpw(password, user.password_hash)
    end
  end

  @doc """
  Gets the user count.

  ## Examples

      iex> get_user_count
      40

  """
  @spec get_user_count :: non_neg_integer()
  def get_user_count do
    User
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  获取全部 user 个数
  """
  @spec get_total_user_count :: non_neg_integer()
  def get_total_user_count do
    User
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Updates user password.
  """
  @spec update_user_password(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def update_user_password(user, attrs) do
    case check_user_password(user, attrs["current_password"]) do
      true ->
        user
        |> User.update_password_changeset(attrs)
        |> Repo.update()

      _ -> {:error, "Invalid current password"}
    end
  end

  @doc """
  Mark the current user verified
  """
  def mark_as_verified(user) do
    attrs = %{"email_verified_at" => Timex.now}
    update_user(user, attrs)
  end

  @doc """
  找回密码-重置密码
  """
  def update_reset_password(user, attrs) do
    user
    |> User.reset_password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Github 登录应对。
  """
  def login_or_register_from_github(%{nickname: nickname, name: nil, email: _email} = user) do
    login_or_register_from_github(%{user | name: nickname})
  end

  def login_or_register_from_github(%{nickname: nickname, name: _name, email: nil} = user) do
    login_or_register_from_github(%{user | email: nickname <> "@users.noreply.github.com"})
  end

  def login_or_register_from_github(%{nickname: nickname, name: name, email: email}) do
    case get_user_by_username(nickname) do
      nil ->
        create_user(%{
          email: email,
          username: nickname
        })

      user ->
        {:ok, user}
    end
  end

  @doc """
  获取 用户或组织的 github repos，这里会借助缓存处理。

  ## TODO

      需要队列处理

  ## Example

      iex> github_repositories(user)
      [%{}, %{}]

      iex> github_repositories(user)
      []

  """
  def github_repositories(%User{} = user) do
    user
    |> github_repos_cache_key
    |> Store.get!
    |> fetch_github_repos(user)
  end

  def github_repositories(%Team{} = team) do
    team
    |> github_repos_cache_key
    |> Store.get!
    |> fetch_github_repos(team)
  end

  # 获取 github repos 信息
  defp fetch_github_repos(items, target) when is_nil(items) do
    repos =
      target
      |> github_repos_url
      |> HTTPoison.get!
      |> handle_response

    Store.put!(github_repos_cache_key(target), repos)
    repos
  end
  defp fetch_github_repos(items, _) do
    items
  end

  # 拉取数据，并且 Json 处理
  defp handle_response(%HTTPoison.Response{body: body, status_code: 200}) do
    body
    |> Jason.decode!
    |> Enum.map(&(Map.take(&1, ~w(name html_url watchers language description))))
    |> Enum.sort(&(&1["watchers"] >= &2["watchers"]))
    |> Enum.take(10)
  end
  defp handle_response(%HTTPoison.Response{body: _, status_code: 404}) do
    []
  end

  # 获取缓存 cache_key
  defp github_repos_cache_key(target) do
    "github-repos:" <> github_handle(target)
  end

  # 请求获取 github 用户的 repos 的 Url
  defp github_repos_url(target) do
    "https://api.github.com/users/#{github_handle(target)}/repos?type=owner&sort=pushed"
  end

  @doc """
  获取 user 或 team 的 github 账号。
  """
  def github_handle(%User{} = user) do
    user.github_handle || user.username
  end
  def github_handle(%Team{} = team) do
    team.github_handle || team.name
  end

  alias Mipha.Accounts.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id) do
    Location
    |> Repo.get!(id)
    |> Repo.preload([:users])
  end

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{source: %Location{}}

  """
  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end

  alias Mipha.Accounts.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload([:users, :owner])
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %Team{}}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end

  alias Mipha.Accounts.UserTeam

  @doc """
  Returns the list of users_teams.

  ## Examples

      iex> list_users_teams()
      [%UserTeam{}, ...]

  """
  def list_users_teams do
    Repo.all(UserTeam)
  end

  @doc """
  Gets a single user_team.

  Raises `Ecto.NoResultsError` if the User team does not exist.

  ## Examples

      iex> get_user_team!(123)
      %UserTeam{}

      iex> get_user_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_team!(id), do: Repo.get!(UserTeam, id)

  @doc """
  Creates a user_team.

  ## Examples

      iex> create_user_team(%{field: value})
      {:ok, %UserTeam{}}

      iex> create_user_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_team(attrs \\ %{}) do
    %UserTeam{}
    |> UserTeam.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_team.

  ## Examples

      iex> update_user_team(user_team, %{field: new_value})
      {:ok, %UserTeam{}}

      iex> update_user_team(user_team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_team(%UserTeam{} = user_team, attrs) do
    user_team
    |> UserTeam.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserTeam.

  ## Examples

      iex> delete_user_team(user_team)
      {:ok, %UserTeam{}}

      iex> delete_user_team(user_team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_team(%UserTeam{} = user_team) do
    Repo.delete(user_team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_team changes.

  ## Examples

      iex> change_user_team(user_team)
      %Ecto.Changeset{source: %UserTeam{}}

  """
  def change_user_team(%UserTeam{} = user_team) do
    UserTeam.changeset(user_team, %{})
  end
end
