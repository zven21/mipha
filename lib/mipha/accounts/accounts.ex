defmodule Mipha.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Comeonin.Bcrypt
  alias Mipha.Repo
  alias Mipha.Accounts.User

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
      _   -> Bcrypt.checkpw(password, user.password_hash)
    end
  end
end
