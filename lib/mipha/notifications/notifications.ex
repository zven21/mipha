defmodule Mipha.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias Mipha.Repo

  alias Mipha.Notifications.Notification

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

  alias Mipha.Notifications.UserNotification

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
end
