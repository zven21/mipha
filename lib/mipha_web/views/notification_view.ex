defmodule MiphaWeb.NotificationView do
  use MiphaWeb, :view

  alias Mipha.Notifications

  def group_by(notifications) do
    notifications
    |> Enum.group_by(&Timex.format!(&1.updated_at, "{YYYY}-{0M}-{D}"))
  end

  def transfer_action(notification) do
    target_object = Notifications.object(notification)
    actor = Notifications.actor(notification)

    render("_#{Atom.to_string(notification.action)}.html",
      actor: actor,
      target_object: target_object
    )
  end

  def hour_format(notification) do
    Timex.format!(notification.updated_at, "{h24}:{m}")
  end
end
