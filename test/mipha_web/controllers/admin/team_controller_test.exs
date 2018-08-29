defmodule MiphaWeb.Admin.TeamControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "lists all teams on index", %{conn: conn} do
    t1 = insert(:team)
    t2 = insert(:team)
    conn = get(conn, admin_team_path(conn, :index))

    assert conn.status == 200
    assert conn.resp_body =~ t1.name
    assert conn.resp_body =~ t2.name
  end

  @tag :as_admin
  test "deletes team, and redirectes", %{conn: conn} do
    t = insert(:team)
    conn = delete(conn, admin_team_path(conn, :delete, t.id))

    assert redirected_to(conn) == admin_team_path(conn, :index)
  end
end
