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
end
