defmodule MiphaWeb.Admin.NodeControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Topics.Node

  @valid_attrs %{name: "some node"}
  @invalid_attrs %{name: nil}

  @tag :as_admin
  test "lists all nodes on index", %{conn: conn} do
    # n1 = insert(:node)
    # n2 = insert(:node)
    conn = get(conn, admin_node_path(conn, :index))
    assert conn.status == 200
    # assert conn.resp_body =~ n1.name
    # assert conn.resp_body =~ n2.name
  end

  @tag :as_admin
  test "creates node with valid attributes, and redirects", %{conn: conn} do
    conn = post(conn, admin_node_path(conn, :create), node: @valid_attrs)
    node = Repo.one(from t in Node, where: t.name == ^@valid_attrs[:name])

    assert redirected_to(conn) == admin_node_path(conn, :show, node.id)
    assert node.name == @valid_attrs[:name]
  end

  @tag :as_admin
  test "does not create node with invalid attributes", %{conn: conn} do
    count_before = count(Node)
    conn = post(conn, admin_node_path(conn, :create), node: @invalid_attrs)

    assert conn.status == 200
    assert count(Node) == count_before
  end

  @tag :as_admin
  test "updates node", %{conn: conn} do
    n = insert(:node)
    conn = put(conn, admin_node_path(conn, :update, n.id), node: @valid_attrs)

    assert redirected_to(conn) == admin_node_path(conn, :show, n.id)
  end

  # @tag :as_admin
  # test "renders form to create new node", %{conn: conn} do
  #   conn = get(conn, admin_node_path(conn, :new))
  #   assert html_response(conn, 200) =~ ~r/new/
  # end

  # @tag :as_admin
  # test "renders form to create edit node", %{conn: conn} do
  #   n = insert(:node)
  #   conn = get(conn, admin_node_path(conn, :edit, n.id))
  #   assert html_response(conn, 200) =~ ~r/edit/
  # end

  @tag :as_admin
  test "deletes node", %{conn: conn} do
    n = insert(:node)
    conn = delete(conn, admin_node_path(conn, :delete, n.id))

    assert redirected_to(conn) == admin_node_path(conn, :index)
    # assert count(Node) == 0
  end
end
