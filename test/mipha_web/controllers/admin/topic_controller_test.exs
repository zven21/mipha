defmodule MiphaWeb.Admin.TopicControllerTest do
  use MiphaWeb.ConnCase

  describe "index" do
    test "lists all topics", %{conn: conn} do
      conn = get conn, admin_topic_path(conn, :index)
      assert html_response(conn, 200) =~ "#"
    end
  end
end
