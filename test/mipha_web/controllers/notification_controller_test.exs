defmodule MiphaWeb.NotificationControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_user
  test "lists all notifications", %{conn: conn} do
    # n1 = insert(:notification, user: user)
    # n2 = insert(:notification, user: user)
    conn = get(conn, notification_path(conn, :index))

    assert conn.status == 200
  end

  @tag :as_user
  test "makes user notifications read" do
  end

  @tag :as_user
  test "deletes user notification" do
  end
end
