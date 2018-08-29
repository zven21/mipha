defmodule MiphaWeb.Admin.CompanyControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_admin
  test "lists all companies on index", %{conn: conn} do
    c1 = insert(:company)
    c2 = insert(:company)

    conn = get(conn, admin_company_path(conn, :index))
    assert conn.status == 200
    assert conn.resp_body =~ c1.name
    assert conn.resp_body =~ c2.name
  end
end
