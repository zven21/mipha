defmodule MiphaWeb.NotificationController do
  use MiphaWeb, :controller

  alias Mipha.Notifications

  plug MiphaWeb.Plug.RequireUser

  def index(conn, params) do
    result =
      conn
      |> current_user()
      |> Notifications.Queries.cond_user_notifications()
      |> Trubo.Ecto.trubo(params)

    render conn, :index,
      notifications: result.datas,
      paginate: result.paginate
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
