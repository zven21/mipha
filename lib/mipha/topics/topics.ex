defmodule Mipha.Topics do
  @moduledoc """
  The Topics context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Topics.Topic

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Topic
    |> Repo.all()
    |> Repo.preload([:node, :user, :last_reply_user])
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
  def get_topic!(id), do: Repo.get!(Topic, id)

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
    attrs = attrs |> Map.put(:user_id, user.id)

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

  defp filter_from_clauses(opts) do
    cond do
      Keyword.get(opts, :type) == :jobs -> Topic.job
      Keyword.get(opts, :type) == :educational -> Topic.educational
      Keyword.get(opts, :type) == :featured -> Topic.featured
      Keyword.get(opts, :type) == :no_reply -> Topic.no_reply
      Keyword.get(opts, :type) == :popular -> Topic.popular
      Keyword.has_key?(opts, :node) -> opts |> Keyword.get(:node) |> Topic.by_node
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Topic.by_user
      true -> Topic
    end
  end

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
