defmodule Mipha.Stars do
  @moduledoc """
  The Stars context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Mipha.{
    Repo,
    Stars,
    Topics,
    Replies,
    Accounts,
    Notifications
  }

  alias Stars.Star
  alias Topics.Topic
  alias Replies.Reply
  alias Accounts.User

  @type starrable :: Topic.t() | Reply.t()

  @doc """
  Returns the list of stars.

  ## Examples

      iex> list_stars()
      [%Star{}, ...]

  """
  def list_stars do
    Repo.all(Star)
  end

  @doc """
  Gets a single star.

  Raises `Ecto.NoResultsError` if the Star does not exist.

  ## Examples

      iex> get_star!(123)
      %Star{}

      iex> get_star!(456)
      ** (Ecto.NoResultsError)

  """
  def get_star!(id), do: Repo.get!(Star, id)

  @doc """
  Creates a star.

  ## Examples

      iex> create_star(%{field: value})
      {:ok, %Star{}}

      iex> create_star(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_star(attrs \\ %{}) do
    %Star{}
    |> Star.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a star.

  ## Examples

      iex> update_star(star, %{field: new_value})
      {:ok, %Star{}}

      iex> update_star(star, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_star(%Star{} = star, attrs) do
    star
    |> Star.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Star.

  ## Examples

      iex> delete_star(star)
      {:ok, %Star{}}

      iex> delete_star(star)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_star(Star.t()) :: {:ok, Star.t()} | nil
  def delete_star(%Star{} = star) do
    Repo.delete(star)
  end

  @spec delete_star(Keyword.t()) :: {:ok, Star.t()} | nil
  def delete_star(clauses) do
    clauses
    |> get_star
    |> Repo.delete
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking star changes.

  ## Examples

      iex> change_star(star)
      %Ecto.Changeset{source: %Star{}}

  """
  def change_star(%Star{} = star) do
    Star.changeset(star, %{})
  end

  @doc """
  Gets a star.

  ## Examples

      iex> get_star(user_id: 123, topic_id: 123)
      %Star{}

      iex> get_star(user_id: 123, topic_id: 456)
      nil

  """
  @spec get_star(Keyword.t()) :: Star.t() | nil
  def get_star(clauses) when length(clauses) == 2, do: Repo.get_by(Star, clauses)

  @doc """
  Returns the starrable of the star.

  ## Examples

      iex> starrable(%Star{})
      %Topic{}

      iex> starrable(%Star{})
      %Reply{}

  """
  @spec starrable(Star.t()) :: Topic.t() | Reply.t()
  def starrable(%Star{topic_id: topic_id} = star) when not is_nil(topic_id) do
    star
    |> Star.preload_topic()
    |> Map.fetch!(:topic)
  end

  def starrable(%Star{reply_id: reply_id} = star) when not is_nil(reply_id) do
    star
    |> Star.preload_reply()
    |> Map.fetch!(:reply)
  end

  @doc """
  Inserts a star.
  """
  # @spec insert_star(map()) :: {:ok, Star.t()} | {:error, }
  def insert_star(attrs) do
    start_changeset = Star.changeset(%Star{}, attrs)

    Multi.new()
    |> Multi.insert(:star, start_changeset)
    |> notify_author_of_starrable()
    |> Repo.transaction()
  end

  defp notify_author_of_starrable(multi) do
    insert_notification_fn = fn %{star: star} ->
      starrable = starrable(star)

      author =
        case starrable do
          %Topic{} = topic -> Topics.author(topic)
          %Reply{} = reply -> Replies.author(reply)
        end

      action =
        case starrable do
          %Topic{} -> "topic_starred"
          %Reply{} -> "reply_starred"
        end

      notified_users = [author]

      notification_attrs =
        starrable
        |> case do
          %Topic{id: topic_id} -> %{topic_id: topic_id}
          %Reply{id: reply_id} -> %{reply_id: reply_id}
        end
        |> Map.merge(%{
          actor_id: author.id,
          action: action,
          notified_users: notified_users
        })

      case Notifications.insert_notification(notification_attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notification, insert_notification_fn)
  end

  # defp starrable_author(%Topic{} = topic), do: Topics.author(topic)
  # defp starrable_author(%Reply{} = reply), do: Replies.author(reply)

  @doc """
  Returns `true` if the user has starred the starrable.
  `false` otherwise.

  ## Examples

      iex> has_starred?(user: %User{}, topic: %Topic{})
      true

      iex> has_starred?(user: %User{}, topic: %Topic{})
      false

  """
  @spec has_starred?(Keyword.t()) :: boolean
  def has_starred?(clauses) do
    %User{id: user_id} = Keyword.get(clauses, :user)

    clauses =
      clauses
      |> get_starrable_from_clauses()
      |> case do
        %Topic{id: topic_id} -> [topic_id: topic_id]
        %Reply{id: reply_id} -> [reply_id: reply_id]
      end
      |> Keyword.put(:user_id, user_id)

    get_star(clauses)
  end

  @spec get_starrable_from_clauses(Keyword.t()) :: starrable()
  defp get_starrable_from_clauses(clauses) do
    cond do
      Keyword.has_key?(clauses, :topic) -> Keyword.get(clauses, :topic)
      Keyword.has_key?(clauses, :reply) -> Keyword.get(clauses, :reply)
      true -> Star
    end
  end

  @doc """
  Return starrable count.
  """
  @spec get_starred_count(Keyword.t()) :: non_neg_integer()
  def get_starred_count(clauses) do
    clauses
    |> get_starrable_from_clauses()
    |> case do
      %Topic{} = topic -> Star.by_topic(topic)
      %Reply{} = reply -> Star.by_reply(reply)
    end
    |> Repo.aggregate(:count, :id)
  end
end
