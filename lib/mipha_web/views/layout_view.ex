defmodule MiphaWeb.LayoutView do
  use MiphaWeb, :view

  alias Mipha.Notifications

  @doc """
  判断是否有未读的 notification
  """
  def has_unread_notification?(user) do
    Notifications.unread_notification_count(user) > 0
  end

  @doc """
  获取未读的 notification 个数
  """
  def unread_notification_count(user) do
    Notifications.unread_notification_count(user)
  end
end
