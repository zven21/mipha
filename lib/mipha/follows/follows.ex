defmodule Mipha.Follows do
  @moduledoc """
  The Follows context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Mipha.{
    Repo,
    Follows,
    Accounts,
    Notifications
  }
  alias Follows.Follow
  alias Accounts.User

  @doc """
  Returns the list of follows.

  ## Examples

      iex> list_follows()
      [%Follow{}, ...]

  """
  def list_follows do
    Repo.all(Follow)
  end

  @doc """
  Gets a single follow.

  Raises `Ecto.NoResultsError` if the Follow does not exist.

  ## Examples

      iex> get_follow!(123)
      %Follow{}

      iex> get_follow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_follow!(id), do: Repo.get!(Follow, id)

  @doc """
  Gets a single follow.

  ## Examples

      iex> get_follow(123)
      %Follow{}

      iex> get_follow(456)
      nil

      iex> get_follow(follower_id: 123, user_id: 456)
      %Follow{}

      iex> get_follow(follower_id: 123, user_id: 458)
      nil

  """
  @spec get_follow(String.t() | non_neg_integer) :: Follow.t() | nil
  def get_follow(id) when not is_list(id), do: Repo.get(Follow, id)

  @spec get_follow(Keyword.t()) :: Follow.t() | nil
  def get_follow(clauses) when length(clauses) == 2, do: Repo.get_by(Follow, clauses)

  @doc """
  Creates a follow.

  ## Examples

      iex> create_follow(%{field: value})
      {:ok, %Follow{}}

      iex> create_follow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_follow(attrs \\ %{}) do
    %Follow{}
    |> Follow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a follow.

  ## Examples

      iex> update_follow(follow, %{field: new_value})
      {:ok, %Follow{}}

      iex> update_follow(follow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_follow(%Follow{} = follow, attrs) do
    follow
    |> Follow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Follow.

  ## Examples

      iex> delete_follow(follow)
      {:ok, %Follow{}}

      iex> delete_follow(follow)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_follow(Follow.t()) :: {:ok, Follow.t()} | {:error, Ecto.Changeset.t()}
  def delete_follow(%Follow{} = follow) do
    Repo.delete(follow)
  end

  @spec delete_follow(Keyword.t()) :: {:ok, Follow.t()} | {:error, Ecto.Changeset.t()}
  def delete_follow(clauses) when length(clauses) == 2 do
    clauses
    |> get_follow
    |> Repo.delete
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking follow changes.

  ## Examples

      iex> change_follow(follow)
      %Ecto.Changeset{source: %Follow{}}

  """
  def change_follow(%Follow{} = follow) do
    Follow.changeset(follow, %{})
  end

  @doc """
  Filter the list of topics.

  ## Examples

      iex> cond_follows()
      Ecto.Query.t()

      iex> cond_follows(user: %User{})
      Ecto.Query.t()

      iex> cond_follows(follower: %User{})
      Ecto.Query.t()

  """
  @spec cond_follows(Keyword.t()) :: Ecto.Query.t()
  def cond_follows(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:user, :follower])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :follower) -> opts |> Keyword.get(:follower) |> Follow.by_follower
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Follow.by_user
      true -> Follow
    end
  end

  @doc """
  Unfollow user.

  ## Examples

      follow_user(follower: %User{}, user: %User{})
      {:ok, follow}

      follow_user(follower: %User{}, user: %User{})
      {:error, _}

  """
  @spec unfollow_user(Keyword.t()) :: {:ok, Follow.t()} | {:error, any()}
  def unfollow_user(follower: follower, user: user) do
    opts = [follower: follower, user: user]
    if can_follow?(opts) do
      if has_followed?(opts) do
        delete_follow(user_id: user.id, follower_id: follower.id)
      else
        {:error, "Unfollow already."}
      end
    else
      {:error, "Can not follower yourself."}
    end
  end

  @doc """
  Follow user.
  ## Examples

      follow_user(follower: %User{}, user: %User{})
      {:ok, follow}

      follow_user(follower: %User{}, user: %User{})
      {:error, _}

  """
  @spec follow_user(Keyword.t()) :: {:ok, Follow.t()} | {:error, any()}
  def follow_user(follower: follower, user: user) do
    opts = [follower: follower, user: user]
    if can_follow?(opts) do
      if has_followed?(opts) do
        {:error, "Follow already."}
      else
        insert_follow(%{user_id: user.id, follower_id: follower.id})
      end
    else
      {:error, "Can't follower yourself."}
    end
  end

  @doc """
  Returns `true` if the follower can follow the followable.
  `false` otherwise.
  """
  @spec can_follow?(Keyword.t()) :: boolean
  def can_follow?(clauses) do
    %User{id: follower_id} = Keyword.get(clauses, :follower)
    %User{id: user_id} = Keyword.get(clauses, :user)

    user_id == follower_id && false || true
  end

  @doc """
  Returns `true` if the user has followed the followable.
  `false` otherwise.

  ## Examples

      iex> has_followed?(follower: %User{}, user: %User{})
      true

      iex> has_followed?(follower: %User{}, topic: %Topic{})
      false

  """
  @spec has_followed?(Keyword.t()) :: boolean
  def has_followed?(clauses) do
    # FIXME 这里添加 can_follow? 的逻辑
    %User{id: follower_id} = Keyword.get(clauses, :follower)
    %User{id: user_id} = Keyword.get(clauses, :user)

    opts = [follower_id: follower_id, user_id: user_id]
    get_follow(opts)
  end

  @doc """
  Insert a follow.

  ## Examples

      iex> insert_follow(attrs)
      {:ok, %Follow{}}

      iex> insert_follow(attrs)
      {:error, %Ecto.Changeset{}}

  """
  def insert_follow(attrs \\ %{}) do
    follow_changeset = Follow.changeset(%Follow{}, attrs)

    Multi.new()
    |> Multi.insert(:follow, follow_changeset)
    |> notify_followee_of_follow()
    |> Repo.transaction()
  end

  defp notify_followee_of_follow(multi) do
    insert_notification_fn = fn %{follow: follow} ->
      followee =
        follow
        |> Follow.preload_user()
        |> Map.fetch!(:user)

      notified_users = [followee]

      notification_attrs = %{
        user_id: followee.id,
        actor_id: follow.follower_id,
        action: "followed",
        notified_users: notified_users
      }

      case Notifications.insert_notification(notification_attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notification_of_follow, insert_notification_fn)
  end

  @doc """
  Gets the follower count of a followable.

  ## Examples

      iex> get_follower_count([user: %User{}])
      4

      iex> get_follower_count([artwork: %Artwork{}])
      8

      iex> get_follower_count([topic: %Topic{}])
      12

  """
  @spec get_follower_count(Keyword.t()) :: non_neg_integer()
  def get_follower_count(clauses) do
    query =
      clauses
      |> Keyword.get(:user)
      |> Follow.by_user

    query
    |> join(:inner, [c], u in assoc(c, :follower))
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets the followee count of a user.

  ## Examples

    iex> get_followee_count(%User{})
    42

  """
  @spec get_followee_count(User.t()) :: non_neg_integer()
  def get_followee_count(%User{} = user) do
    user
    |> Follow.by_follower()
    |> Repo.aggregate(:count, :id)
  end
end
