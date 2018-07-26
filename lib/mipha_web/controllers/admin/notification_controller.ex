defmodule MiphaWeb.Admin.NotificationController do
  use MiphaWeb, :controller

  alias Mipha.Notifications

  def index(conn, _params) do
    notifications = Notifications.list_notifications()
    render(conn, "index.html", notifications: notifications)
  end

  def show(conn, %{"id" => id}) do
    notification = Notifications.get_notification!(id)
    render(conn, "show.html", notification: notification)
  end

  def delete(conn, %{"id" => id}) do
    notification = Notifications.get_notification!(id)
    {:ok, _notification} = Notifications.delete_notification(notification)

    conn
    |> put_flash(:info, "Notification deleted successfully.")
    |> redirect(to: admin_notification_path(conn, :index))
  end
end
