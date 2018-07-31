defmodule Mipha.Notifications.Queries do
  @moduledoc false

  import Ecto.Query

  alias Mipha.Accounts.User
  alias Mipha.Notifications.UserNotification

  @doc """
  Returns current_user notification.
  """
  @spec cond_user_notifications(User.t()) :: Ecto.Query.t()
  def cond_user_notifications(%User{} = user) do
    user
    |> UserNotification.by_user()
    |> preload([:user, :notification])
  end
end
