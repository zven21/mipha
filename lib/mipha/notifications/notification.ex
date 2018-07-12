defmodule Mipha.Notifications.Notification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.Accounts.User
  alias Mipha.Topics.Topic
  alias Mipha.Replies.Reply
  alias Mipha.Notifications.{Notification, UserNotification}

  @type t :: %Notification{}

  schema "notifications" do
    field :action, :string

    belongs_to :actor, User, foreign_key: :actor_id
    belongs_to :reply, Reply
    belongs_to :topic, Topic
    belongs_to :user, User

    has_many :user_notifications, UserNotification

    many_to_many :notified_users, User, join_through: UserNotification

    timestamps()
  end

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
      actor_id
    )a

    notification
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
