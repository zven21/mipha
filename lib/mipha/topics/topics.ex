defmodule Mipha.Topics do
  @moduledoc """
  The Topics context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Topics.Topic
  alias Mipha.Accounts.User

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Topic
    |> Repo.all()
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
    |> Repo.preload([:node, :user, :last_reply_user, [replies: [:user, [parent: :user]]]])
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  @doc """
  Inserts a topic.

  ## Examples

      iex> insert_topic(%User{}, %{field: value})
      {:ok, %Topic{}}

      iex> insert_topic(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec insert_topic(User.t(), map()) :: {:ok, Topic.t()} | {:error, Ecto.Changeset.t()}
  def insert_topic(user, attrs \\ %{}) do
    attrs = attrs |> Map.put("user_id", user.id)

    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Filter the list of topics.

  ## Examples

      iex> cond_topics()
      Ecto.Query.t()

      iex> cond_topics(type: :educational)
      Ecto.Query.t()

      iex> cond_topics(node: %Node{})
      Ecto.Query.t()

      iex> cond_topics(user: %User{})
      Ecto.Query.t()

  """
  @spec cond_topics(Keyword.t()) :: Ecto.Query.t() | nil
  def cond_topics(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:user, :node, :last_reply_user])
  end

  # FIXME
  defp filter_from_clauses(opts) do
    do_filter_from_clauses(opts)
  end

  defp do_filter_from_clauses(type: :jobs), do: Topic.job
  defp do_filter_from_clauses(type: :educational), do: Topic.educational
  defp do_filter_from_clauses(type: :featured), do: Topic.featured
  defp do_filter_from_clauses(type: :no_reply), do: Topic.no_reply
  defp do_filter_from_clauses(type: :popular), do: Topic.popular
  defp do_filter_from_clauses(node: node), do: Topic.by_node(node)
  defp do_filter_from_clauses(user: user), do: Topic.by_user(user)
  defp do_filter_from_clauses(user_ids: user_ids), do: Topic.by_user_ids(user_ids)
  defp do_filter_from_clauses(_), do: Topic

  @doc """
  Returns the featured of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_featured_topics do
    Topic.featured
    |> Repo.all()
    |> Repo.preload([:node, :user, :last_reply_user])
  end

  @doc """
  Return topic count of a owner(user).
  """
  @spec get_topic_count(User.t()) :: non_neg_integer()
  def get_topic_count(%User{} = user) do
    Topic
    |> Topic.by_user(user)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Return the recent of topics.
  """
  @spec recent_topics(User.t()) :: [Topic.t()] | nil
  def recent_topics(%User{} = user) do
    user
    |> Topic.by_user
    |> Topic.recent
    |> Repo.all
    |> Repo.preload([:node, :user, :last_reply_user])
  end

  alias Mipha.Topics.Node

  @doc """
  Returns the list of nodes.

  ## Examples

      iex> list_nodes()
      [%Node{}, ...]

  """
  def list_nodes do
    Repo.all(Node)
  end

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id), do: Repo.get!(Node, id)

  @doc """
  Creates a node.

  ## Examples

      iex> create_node(%{field: value})
      {:ok, %Node{}}

      iex> create_node(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node.

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{source: %Node{}}

  """
  def change_node(%Node{} = node) do
    Node.changeset(node, %{})
  end

  @doc """
  Returns the parent of nodes
  """
  @spec list_parent_nodes :: [Node.t()] | nil
  def list_parent_nodes do
    Node.is_parent
    |> Repo.all
    |> Node.preload_children
  end
end
