defmodule Mipha.Replies do
  @moduledoc """
  The Replies context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Replies.Reply
  alias Mipha.Topics.Topic
  alias Mipha.Accounts.User

  @doc """
  Returns the list of repies.

  ## Examples

      iex> list_repies()
      [%Reply{}, ...]

  """
  def list_repies do
    Repo.all(Reply)
  end

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123)
      %Reply{}

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Creates a reply.

  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reply.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{source: %Reply{}}

  """
  def change_reply(%Reply{} = reply) do
    Reply.changeset(reply, %{})
  end

  @doc """
  Filter the list of repies.

  ## Examples

      iex> cond_replies()
      Ecto.Query.t()

      iex> cond_replies(user: %User{})
      Ecto.Query.t()

  """
  @spec cond_replies(Keyword.t()) :: Ecto.Query.t() | nil
  def cond_replies(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:topic, :user])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Reply.by_user
      Keyword.has_key?(opts, :topic) -> opts |> Keyword.get(:topic) |> Reply.by_topic
      true -> Reply
    end
  end

  @doc """
  Get the reply count of a replyable.

  ## Examples

      iex> get_reply_count(user: %User{})
      10

      iex> get_reply_count(topic: %Topic{})
      2

  """
  @spec get_reply_count(Keyword.t()) :: non_neg_integer()
  def get_reply_count(clauses) do
    query =
      clauses
      |> get_replyable_from_clauses()
      |> case do
        %Topic{} = topic -> Reply.by_topic(topic)
        %Reply{} = reply -> Reply.by_parent(reply)
        %User{} = user -> Reply.by_user(user)
      end

    query
    |> join(:inner, [r], u in assoc(r, :user))
    |> Repo.aggregate(:count, :id)
  end

  defp get_replyable_from_clauses(clauses) do
    cond do
      Keyword.has_key?(clauses, :user) -> Keyword.get(clauses, :user)
      Keyword.has_key?(clauses, :topic) -> Keyword.get(clauses, :topic)
      Keyword.has_key?(clauses, :reply) -> Keyword.get(clauses, :reply)
    end
  end

  @doc """
  Return the recent of topics.
  """
  @spec recent_replies(User.t()) :: [Topic.t()] | nil
  def recent_replies(%User{} = user) do
    user
    |> Reply.by_user()
    |> Reply.recent()
    |> Repo.all()
    |> Repo.preload([:topic, :user])
  end
end
