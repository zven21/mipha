defmodule MiphaWeb.Admin.ReplyControllerTest do
  use MiphaWeb.ConnCase

  describe "index" do
    test "lists all replies", %{conn: conn} do
      conn = get conn, admin_reply_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end
end
