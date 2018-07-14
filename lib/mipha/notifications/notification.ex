defmodule Mipha.Notifications.Notification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import EctoEnum, only: [defenum: 3]

  alias Mipha.Repo
  alias Mipha.Accounts.User
  alias Mipha.Topics.Topic
  alias Mipha.Replies.Reply
  alias Mipha.Notifications.{Notification, UserNotification}

  @type t :: %Notification{}

  # 支持如下情况
  # 话题被评论     :topic_reply_added
  # 话题被点赞     :topic_starred
  # 评论被点赞     :reply_starred
  # 评论被评论     :reply_comment_added
  # 话题中被 @     :topic_mentioned
  # 评论中被 @     :reply_mentioned
  # 关注他人       :followed
  # 关注的用户发生的动态
  #   * 发布话题   :topic_added
  #   * 评论话题   :topic_reply_added
  defenum NotificationAction, :notification_action, [
    :topic_reply_added,
    :topic_starred,
    :reply_starred,
    :reply_comment_added,
    :topic_mentioned,
    :reply_mentioned,
    :followed,
    :topic_added
  ]

  schema "notifications" do
    field :action, NotificationAction

    belongs_to :actor, User, foreign_key: :actor_id
    belongs_to :reply, Reply
    belongs_to :topic, Topic
    belongs_to :user, User

    has_many :user_notifications, UserNotification

    many_to_many :notified_users, User, join_through: UserNotification

    timestamps()
  end

  @doc """
  Filters the notifications by actor.
  """
  @spec by_actor(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_actor(query \\ Notification, %User{id: actor_id}),
    do: where(query, [..., n], n.actor_id == ^actor_id)

  @doc """
  Preloads the actor of a notification.
  """
  @spec preload_actor(t()) :: t()
  def preload_actor(%Notification{} = notification), do: Repo.preload(notification, :actor)

  @doc """
  Preloads the topic of a notification.
  """
  @spec preload_topic(t()) :: t()
  def preload_topic(%Notification{} = notification), do: Repo.preload(notification, :topic)

  @doc """
  Preloads the reply of a notification.
  """
  @spec preload_reply(t()) :: t()
  def preload_reply(%Notification{} = notification), do: Repo.preload(notification, :reply)

  @doc """
  Preloads the reply of a notification.
  """
  @spec preload_user(t()) :: t()
  def preload_user(%Notification{} = notification), do: Repo.preload(notification, :user)

  @doc false
  def changeset(notification, attrs) do
    permitted_attrs = ~w(
      action
      actor_id
      topic_id
      reply_id
      user_id
    )a

    required_attrs = ~w(
      action
    )a

    notification
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
    |> assoc_constraint(:actor)
    |> assoc_constraint(:topic)
    |> assoc_constraint(:reply)
    |> assoc_constraint(:user)
    |> maybe_put_notified_users(attrs)
  end

  @spec maybe_put_notified_users(Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  defp maybe_put_notified_users(%Ecto.Changeset{} = changeset, attrs) do
    case Map.get(attrs, :notified_users) do
      value when not is_nil(value) -> put_assoc(changeset, :notified_users, value)
      nil -> changeset
    end
  end
end
