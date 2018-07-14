defmodule Mipha.Notifications.UserNotification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.Repo
  alias Mipha.Accounts.User
  alias Mipha.Notifications.{Notification, UserNotification}

  @type t :: %UserNotification{}

  schema "users_notifications" do
    field :read_at, :naive_datetime

    belongs_to :user, User
    belongs_to :notification, Notification

    timestamps()
  end

  @doc """
  Filters the user notifications by user.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ UserNotification, %User{id: user_id}),
    do: where(query, [..., un], un.user_id == ^user_id)

  @doc """
  Preloads the user of a user notification.
  """
  @spec preload_user(t()) :: t()
  def preload_user(%UserNotification{} = user_notification),
    do: Repo.preload(user_notification, :user)

  @doc """
  标记已读
  """
  @spec update_changeset(t(), map()) :: Ecto.Changeset.t()
  def update_changeset(%UserNotification{} = user_notification, attrs) do
    permitted_attrs = ~w(
      read_at
    )a

    user_notification
    |> cast(attrs, permitted_attrs)
  end

  @doc """
  Changeset
  """
  def changeset(user_notification, attrs) do
    permitted_attrs = ~w(
      user_id
      notification_id
      read_at
    )a

    required_attrs = ~w(
      user_id
      notification_id
    )a

    user_notification
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
