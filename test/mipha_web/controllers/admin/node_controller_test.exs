defmodule MiphaWeb.Admin.NodeControllerTest do
  use MiphaWeb.ConnCase

  describe "index" do
    test "lists all nodes", %{conn: conn} do
      conn = get conn, admin_node_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end
end
