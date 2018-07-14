defmodule MiphaWeb.NotificationView do
  use MiphaWeb, :view

  alias Mipha.Notifications

  def group_by(notifications) do
    notifications
    |> Enum.group_by(&(Timex.format!(&1.updated_at, "{YYYY}-{0M}-{D}")))
  end

  def target_object(notification) do
    Notifications.object(notification)
  end

  def hour_format(notification) do
    Timex.format!(notification.updated_at, "{h24}-{m}")
  end
end
