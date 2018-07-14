defmodule MiphaWeb.NotificationController do
  use MiphaWeb, :controller

  alias Mipha.{
    Repo,
    Notifications
  }

  plug MiphaWeb.Plug.RequireUser

  def index(conn, _) do
    page =
      conn
      |> current_user()
      |> Notifications.cond_user_notifications
      |> Repo.paginate(conn.params)

    render conn, :index,
      notifications: page.entries,
      page: page
  end

  def make_read(conn, _params) do
    conn
    |> current_user()
    |> Notifications.mark_read_notification()

    conn
    |> put_flash(:info, "已全部标记为已读。")
    |> redirect(to: notification_path(conn, :index))
  end

  def clean(conn, _params) do
    conn
    |> current_user()
    |> Notifications.clean_notification()

    conn
    |> put_flash(:info, "已清空通知。")
    |> redirect(to: notification_path(conn, :index))
  end
end
