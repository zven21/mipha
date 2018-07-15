defmodule Mipha.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Mipha.{
    Repo,
    Topics,
    Replies,
    Accounts,
    Notifications
  }

  alias Notifications.{Notification, UserNotification}
  alias Topics.Topic
  alias Replies.Reply
  alias Accounts.User

  @type notification_object :: Topic.t() | Reply.t() | User.t()

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{source: %Notification{}}

  """
  def change_notification(%Notification{} = notification) do
    Notification.changeset(notification, %{})
  end

  @doc """
  标记单个已读
  """
  @spec read_notification(UserNotification.t()) :: {:ok, UserNotification.t()} | {:error, %Ecto.Changeset{}}
  def read_notification(%UserNotification{} = user_notification) do
    attrs = %{read_at: Timex.now}

    user_notification
    |> UserNotification.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  标注所有未读信息为已读
  """
  @spec mark_read_notification(User.t()) :: any
  def mark_read_notification(user) do
    user
    |> UserNotification.by_user()
    |> UserNotification.unread()
    |> Repo.update_all(set: [read_at: Timex.now])
  end

  @doc """
  清空通知
  """
  @spec clean_notification(User.t()) :: any
  def clean_notification(user) do
    user
    |> UserNotification.by_user()
    |> Repo.delete_all()
  end

  @doc """
  获取通知的发送者。

  ## Examples

      iex> actor(%Notification{})
      %User{}

      iex> actor(%Notification{})
      nil

  """
  @spec actor(Notification.t()) :: User.t() | nil
  def actor(%Notification{} = notification) do
    notification
    |> Notification.preload_actor()
    |> Map.get(:actor)
  end

 @doc """
  获取通知对象 topic || reply || user

  ## Examples

      iex> object(%Notification{})
      %Topic{}

      iex> object(%Notification{})
      %Reply{}

      iex> object(%Notification{})
      %User{}

  """
  @spec object(Notification.t()) :: notification_object
  def object(%Notification{topic_id: topic_id} = notification) when not is_nil(topic_id) do
    notification
    |> Notification.preload_topic()
    |> Map.get(:topic)
  end

  def object(%Notification{reply_id: reply_id} = notification) when not is_nil(reply_id) do
    notification
    |> Notification.preload_reply()
    |> Map.get(:reply)
    |> Reply.preload_topic()
    |> Reply.preload_parent()
  end

  def object(%Notification{user_id: user_id} = notification) when not is_nil(user_id) do
    notification
    |> Notification.preload_user()
    |> Map.get(:user)
  end

  def object(_), do: nil

  @doc """
  获取未读的 Notification 个数
  """
  @spec unread_notification_count(User.t()) :: non_neg_integer()
  def unread_notification_count(user) do
    user
    |> UserNotification.by_user()
    |> UserNotification.unread()
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns the list of users_notifications.

  ## Examples

      iex> list_users_notifications()
      [%UserNotification{}, ...]

  """
  def list_users_notifications do
    Repo.all(UserNotification)
  end

  @doc """
  Gets a single user_notification.

  Raises `Ecto.NoResultsError` if the User notification does not exist.

  ## Examples

      iex> get_user_notification!(123)
      %UserNotification{}

      iex> get_user_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_notification!(id), do: Repo.get!(UserNotification, id)

  @doc """
  Creates a user_notification.

  ## Examples

      iex> create_user_notification(%{field: value})
      {:ok, %UserNotification{}}

      iex> create_user_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_notification(attrs \\ %{}) do
    %UserNotification{}
    |> UserNotification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts a notification.
  """
  @spec insert_notification(any) :: {:ok, any} | {:error, any, any, any}
  def insert_notification(attrs) do
    Multi.new()
    |> insert_notification(attrs)
    |> Repo.transaction()
  end

  @spec insert_notification(Multi.t(), map()) :: Multi.t()
  defp insert_notification(multi, attrs) do
    notification_changeset = Notification.changeset(%Notification{}, attrs)

    Multi.insert(multi, :notification, notification_changeset)
  end

  @doc """
  Updates a user_notification.

  ## Examples

      iex> update_user_notification(user_notification, %{field: new_value})
      {:ok, %UserNotification{}}

      iex> update_user_notification(user_notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_notification(%UserNotification{} = user_notification, attrs) do
    user_notification
    |> UserNotification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserNotification.

  ## Examples

      iex> delete_user_notification(user_notification)
      {:ok, %UserNotification{}}

      iex> delete_user_notification(user_notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_notification(%UserNotification{} = user_notification) do
    Repo.delete(user_notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_notification changes.

  ## Examples

      iex> change_user_notification(user_notification)
      %Ecto.Changeset{source: %UserNotification{}}

  """
  def change_user_notification(%UserNotification{} = user_notification) do
    UserNotification.changeset(user_notification, %{})
  end

  # 获取 current_user
  # 通过 current_user 获取 关联的 user_notifications 按照日期倒叙，已天为单位
  # 然后获取单条 notitication 信息, 如果是 topic 就展示 topic

  def cond_user_notifications(%User{} = user) do
    user
    |> UserNotification.by_user()
    |> preload([:user, :notification])
    # |> Enum.group_by(&(Timex.format(&1.updated_at, "{YYYY}-{0M}-{D}")))
  end
end
