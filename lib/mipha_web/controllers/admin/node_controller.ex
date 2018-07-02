defmodule MiphaWeb.Admin.NodeController do
  use MiphaWeb, :controller

  alias Mipha.Topics
  alias Mipha.Topics.Node

  def index(conn, _params) do
    nodes = Topics.list_nodes()
    render(conn, "index.html", nodes: nodes)
  end

  def new(conn, _params) do
    changeset = Topics.change_node(%Node{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"node" => node_params}) do
    case Topics.create_node(node_params) do
      {:ok, node} ->
        conn
        |> put_flash(:info, "Node created successfully.")
        |> redirect(to: admin_node_path(conn, :show, node))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    node = Topics.get_node!(id)
    render(conn, "show.html", node: node)
  end

  def edit(conn, %{"id" => id}) do
    node = Topics.get_node!(id)
    changeset = Topics.change_node(node)
    render(conn, "edit.html", node: node, changeset: changeset)
  end

  def update(conn, %{"id" => id, "node" => node_params}) do
    node = Topics.get_node!(id)

    case Topics.update_node(node, node_params) do
      {:ok, node} ->
        conn
        |> put_flash(:info, "Node updated successfully.")
        |> redirect(to: admin_node_path(conn, :show, node))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", node: node, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    node = Topics.get_node!(id)
    {:ok, _node} = Topics.delete_node(node)

    conn
    |> put_flash(:info, "Node deleted successfully.")
    |> redirect(to: admin_node_path(conn, :index))
  end
end
