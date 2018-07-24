defmodule Mipha.Replies.Reply do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.{
    Repo,
    Topics.Topic,
    Replies.Reply,
    Accounts.User,
    Stars.Star
  }

  @type t :: %Reply{}

  schema "replies" do
    field :content, :string
    field :star_count, :integer, default: 0

    belongs_to :user, User
    belongs_to :topic, Topic
    belongs_to :parent, Reply, foreign_key: :parent_id

    has_many :children, Reply, foreign_key: :parent_id
    has_many :stars, Star

    timestamps()
  end

  @doc """
  Returns the children node.
  """
  @spec is_child(Ecto.Queryable.t()) :: Ecto.Query.t()
  def is_child(query \\ __MODULE__),
    do: from(q in query, where: not is_nil(q.parent_id))

  @doc """
  Filters the topic by reply.
  """
  @spec by_topic(Ecto.Queryable.t(), Topic.t()) :: Ecto.Query.t()
  def by_topic(query \\ __MODULE__, %Topic{id: topic_id}),
    do: where(query, [..., r], r.topic_id == ^topic_id)

  @doc """
  Filters the parent by reply.
  """
  @spec by_parent(Ecto.Queryable.t(), t()) :: Ecto.Query.t()
  def by_parent(query \\ __MODULE__, %__MODULE__{id: parent_id}),
    do: where(query, [..., r], r.parent_id == ^parent_id)

  @doc """
  Filters reply by user.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ __MODULE__, %User{id: user_id}),
    do: where(query, [..., r], r.user_id == ^user_id)

  @doc """
  Get the recent of replies.
  """
  @spec recent(Ecto.Queryable.t()) :: Ecto.Query.t()
  def recent(query \\ __MODULE__),
    do: from(r in query, order_by: [desc: r.id], limit: 10)

  @doc """
  Preloads the user of a reply.
  """
  @spec preload_user(t()) :: t()
  def preload_user(reply), do: Repo.preload(reply, [:user])

  @doc """
  Preloads the topic of a reply.
  """
  @spec preload_topic(t()) :: t()
  def preload_topic(reply), do: Repo.preload(reply, [:topic])

  @doc """
  Preloads the parent of a reply.
  """
  @spec preload_parent(t()) :: t()
  def preload_parent(reply), do: Repo.preload(reply, [:parent])

  @doc false
  def changeset(reply, attrs) do
    permitted_attrs = ~w(
      star_count
      topic_id
      user_id
      parent_id
      content
    )a

    required_attrs = ~w(
      content
      user_id
      topic_id
    )a

    reply
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
