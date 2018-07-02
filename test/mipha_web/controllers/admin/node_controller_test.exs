defmodule MiphaWeb.Admin.NodeControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Topics

  @create_attrs %{name: "some name", parent_id: 42, position: 42, summary: "some summary"}
  @update_attrs %{name: "some updated name", parent_id: 43, position: 43, summary: "some updated summary"}
  @invalid_attrs %{name: nil, parent_id: nil, position: nil, summary: nil}

  def fixture(:node) do
    {:ok, node} = Topics.create_node(@create_attrs)
    node
  end

  describe "index" do
    test "lists all nodes", %{conn: conn} do
      conn = get conn, admin_node_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Nodes"
    end
  end

  describe "new node" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_node_path(conn, :new)
      assert html_response(conn, 200) =~ "New Node"
    end
  end

  describe "create node" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_node_path(conn, :create), node: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_node_path(conn, :show, id)

      conn = get conn, admin_node_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Node"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_node_path(conn, :create), node: @invalid_attrs
      assert html_response(conn, 200) =~ "New Node"
    end
  end

  describe "edit node" do
    setup [:create_node]

    test "renders form for editing chosen node", %{conn: conn, node: node} do
      conn = get conn, admin_node_path(conn, :edit, node)
      assert html_response(conn, 200) =~ "Edit Node"
    end
  end

  describe "update node" do
    setup [:create_node]

    test "redirects when data is valid", %{conn: conn, node: node} do
      conn = put conn, admin_node_path(conn, :update, node), node: @update_attrs
      assert redirected_to(conn) == admin_node_path(conn, :show, node)

      conn = get conn, admin_node_path(conn, :show, node)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, node: node} do
      conn = put conn, admin_node_path(conn, :update, node), node: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Node"
    end
  end

  describe "delete node" do
    setup [:create_node]

    test "deletes chosen node", %{conn: conn, node: node} do
      conn = delete conn, admin_node_path(conn, :delete, node)
      assert redirected_to(conn) == admin_node_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_node_path(conn, :show, node)
      end
    end
  end

  defp create_node(_) do
    node = fixture(:node)
    {:ok, node: node}
  end
end
