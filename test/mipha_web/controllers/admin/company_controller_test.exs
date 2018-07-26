defmodule MiphaWeb.Admin.CompanyControllerTest do
  use MiphaWeb.ConnCase

  describe "index" do
    test "lists all companies", %{conn: conn} do
      conn = get conn, admin_company_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end
end
