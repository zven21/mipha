defmodule Mipha.Notifications.UserNotification do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.Accounts.User
  alias Mipha.Notifications.{Notification, UserNotification}

  @type t :: %UserNotification{}

  schema "users_notifications" do
    field :read_at, :naive_datetime

    belongs_to :user, User
    belongs_to :notification, Notification

    timestamps()
  end

  @doc false
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
