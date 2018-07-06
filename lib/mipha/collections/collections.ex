defmodule Mipha.Collections do
  @moduledoc """
  The Collections context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Collections.Collection
  alias Mipha.Accounts.User
  alias Mipha.Topics.Topic

  @doc """
  Returns the list of collections.

  ## Examples

      iex> list_collections()
      [%Collection{}, ...]

  """
  def list_collections do
    Repo.all(Collection)
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection!(123)
      %Collection{}

      iex> get_collection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id), do: Repo.get!(Collection, id)

  @doc """
  Creates a collection.

  ## Examples

      iex> create_collection(%{field: value})
      {:ok, %Collection{}}

      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Collection.

  ## Examples

      iex> delete_collection(collection)
      {:ok, %Collection{}}

      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @spec delete_collection(Keyword.t()) :: {:ok, Collection.t()} | nil
  def delete_collection(clauses) when length(clauses) == 2 do
    clauses
    |> get_collection
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.

  ## Examples

      iex> change_collection(collection)
      %Ecto.Changeset{source: %Collection{}}

  """
  def change_collection(%Collection{} = collection) do
    Collection.changeset(collection, %{})
  end

  @doc """
  Filter the list of collections.

  ## Examples

      iex> cond_collections()
      Ecto.Query.t()

  """
  @spec cond_collections(Keyword.t()) :: Ecto.Query.t() | nil
  def cond_collections(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:user, [topic: :node]])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Collection.by_user
      Keyword.has_key?(opts, :topic) -> opts |> Keyword.get(:topic) |> Collection.by_topic
      true -> Collection
    end
  end

  @doc """
  Gets the collection count of a user.

  ## Examples

    iex> get_collection_count(%User{})
    42

  """
  @spec get_collection_count(User.t()) :: non_neg_integer()
  def get_collection_count(%User{} = user) do
    user
    |> Collection.by_user()
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a star.

  ## Examples

      iex> get_collection(user_id: 123, topic_id: 123)
      %Star{}

      iex> get_collection(user_id: 123, topic_id: 456)
      nil

  """
  @spec get_collection(Keyword.t()) :: Collection.t() | nil
  def get_collection(clauses) when length(clauses) == 2, do: Repo.get_by(Collection, clauses)

  @doc """
  Returns `true` if the user has starred the starrable.
  `false` otherwise.

  ## Examples

      iex> has_collected?(user: %User{}, topic: %Topic{})
      true

      iex> has_collected?(user: %User{}, topic: %Topic{})
      false

  """
  @spec has_collected?(Keyword.t()) :: boolean
  def has_collected?(clauses) do
    %User{id: user_id} = Keyword.get(clauses, :user)
    %Topic{id: topic_id} = Keyword.get(clauses, :topic)

    opts = [user_id: user_id, topic_id: topic_id]
    get_collection(opts)
  end

  @doc """
  Insert a collection.

  ## Examples

      iex> insert_collection(attrs)
      {:ok, %Follow{}}

      iex> insert_collection(attrs)
      {:error, %Ecto.Changeset{}}

  """
  def insert_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end
end
