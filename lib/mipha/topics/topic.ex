defmodule Mipha.Topics.Topic do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import EctoEnum, only: [defenum: 3]

  alias Mipha.{
    Repo,
    Accounts.User,
    Replies.Reply,
    Stars.Star,
    Collections.Collection
  }

  alias Mipha.Topics.{Topic, Node}

  @type t :: %Topic{}

  # Topic 状态包含:
  # 正常的帖子：normal
  # 加精的帖子：featured
  # 有建设性的帖子：educational
  # 招聘帖子：job
  defenum TopicType, :topic_type, [
    :normal,
    :featured,
    :educational,
    :job
  ]

  schema "topics" do
    field :title, :string
    field :body, :string
    field :type, TopicType
    field :closed_at, :naive_datetime
    field :replied_at, :naive_datetime
    field :suggested_at, :naive_datetime
    field :reply_count, :integer, default: 0
    field :visit_count, :integer, default: 0

    belongs_to :user, User
    belongs_to :node, Node
    belongs_to :last_reply, Reply, foreign_key: :last_reply_id
    belongs_to :last_reply_user, User, foreign_key: :last_reply_user_id

    has_many :replies, Reply
    has_many :stars, Star
    has_many :collections, Collection, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Returns the job of topic.
  """
  @spec job(Ecto.Queryable.t()) :: Ecto.Query.t()
  def job(query \\ __MODULE__),
    do: where(query, [..., t], t.type == ^:job)

  @doc """
  Filters the featured of topics.
  """
  @spec featured(Ecto.Queryable.t()) :: Ecto.Query.t()
  def featured(query \\ __MODULE__),
    do: where(query, [..., t], t.type == ^:featured)

  @doc """
  Filters the educational of topics.
  """
  @spec educational(Ecto.Queryable.t()) :: Ecto.Query.t()
  def educational(query \\ __MODULE__),
    do: where(query, [..., t], t.type == ^:educational)

  @doc """
  Filters the no_reply of topics.
  """
  @spec no_reply(Ecto.Queryable.t()) :: Ecto.Query.t()
  def no_reply(query \\ __MODULE__),
    do: where(query, [..., t], t.reply_count == 0)

  @doc """
  Filters the popular of topics.
  """
  @spec popular(Ecto.Queryable.t()) :: Ecto.Query.t()
  def popular(query \\ __MODULE__),
    do: where(query, [..., t], t.reply_count >= 10)

  @doc """
  Filters the node of topics.
  """
  @spec by_node(Ecto.Queryable.t(), Node.t()) :: Ecto.Query.t()
  def by_node(query \\ __MODULE__, %Node{id: node_id}),
    do: where(query, [..., t], t.node_id == ^node_id)

  @doc """
  Filters the user of topics.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ __MODULE__, %User{id: user_id}),
    do: where(query, [..., t], t.user_id == ^user_id)

  @doc """
  Filters the user of topics.
  """
  @spec by_user_ids(Ecto.Queryable.t(), List.t()) :: Ecto.Query.t()
  def by_user_ids(query \\ __MODULE__, list),
    do: where(query, [..., t], t.user_id in ^list)

  @doc """
  近10篇帖子
  """
  @spec recent(t()) :: t()
  def recent(query \\ __MODULE__),
    do: from(t in query, order_by: [desc: t.updated_at], limit: 10)

  @doc """
  帖子列表的默认排序，按照 suggested_at updated_at 倒叙
  """
  @spec base_order(t()) :: t()
  def base_order(query \\ __MODULE__),
    do: from(t in query, order_by: [asc: t.suggested_at], order_by: [desc: t.updated_at])

  @doc """
  Preloads the user of a topic.
  """
  @spec preload_user(t()) :: t()
  def preload_user(topic), do: Repo.preload(topic, [:user, :last_reply_user])

  @doc """
  Preloads the reply of a topic.
  """
  @spec preload_replies(t()) :: t()
  def preload_replies(topic), do: Repo.preload(topic, :replies)

  @doc """
  Preloads the reply of a topic.
  """
  @spec preload_node(t()) :: t()
  def preload_node(topic), do: Repo.preload(topic, :node)

  @doc """
  Preloads all of a topic.
  """
  @spec preload_all(t()) :: t()
  def preload_all(topic) do
    topic
    |> preload_replies
    |> preload_user
    |> preload_node
  end

  @doc """
  Topic 自增/自减 计数器
  """
  def counter(%Topic{id: topic_id}, :inc, :visit_count) do
    Topic
    |> where([..., t], t.id == ^topic_id)
    |> Repo.update_all(inc: [visit_count: 1])
  end

  def counter(%Topic{id: topic_id}, :inc, :reply_count) do
    Topic
    |> where([..., t], t.id == ^topic_id)
    |> Repo.update_all(inc: [reply_count: 1])
  end

  def counter(%Topic{id: topic_id}, :dec, :reply_count) do
    Topic
    |> where([..., t], t.id == ^topic_id)
    |> Repo.update_all(inc: [reply_count: -1])
  end

  @doc false
  def changeset(topic, attrs) do
    permitted_attrs = ~w(
      title
      body
      closed_at
      user_id
      type
      node_id
      visit_count
      reply_count
      last_reply_id
      last_reply_user_id
      replied_at
      suggested_at
    )a

    required_attrs = ~w(
      title
      body
      node_id
      user_id
    )a

    topic
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
