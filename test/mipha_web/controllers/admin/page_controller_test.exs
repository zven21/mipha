defmodule MiphaWeb.Admin.PageControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "GET /", %{conn: conn} do
    conn = get(conn, admin_page_path(conn, :index))
    assert conn.status == 200
  end
end
