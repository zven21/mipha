defmodule MiphaWeb.TopicController do
  use MiphaWeb, :controller

  alias Mipha.{Repo, Topics}
  alias Topics.Topic

  plug MiphaWeb.Plug.RequireUser when action in ~w(new create)a

  @intercepted_action ~w(index jobs no_reply popular featured educational)a

  def action(conn, _) do
    if Enum.member?(@intercepted_action, action_name(conn)) do
      opts =
        if conn.params["node_id"] do
          [node: Topics.get_node!(conn.params["node_id"])]
        else
          [type: action_name(conn)]
        end

      parent_nodes = Topics.list_parent_nodes

      page =
        opts
        |> Topics.cond_topics
        |> Repo.paginate(conn.params)

      render conn, action_name(conn),
        asset: "topics",
        topics: page.entries,
        page: page,
        parent_nodes: parent_nodes
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def new(conn, _params) do
    changeset = Topics.change_topic(%Topic{})
    parent_nodes = Topics.list_parent_nodes

    render conn, :new,
      changeset: changeset,
      parent_nodes: parent_nodes
  end

  def create(conn, %{"topic" => topic_params}) do
    attrs = %{
      title: topic_params["title"],
      body: topic_params["body"],
      node_id: topic_params["node_id"]
    }
    case Topics.insert_topic(current_user(conn), attrs) do
      {:ok, topic} ->
        conn
        |> put_flash(:success, "Topic created successfully.")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        parent_nodes = Topics.list_parent_nodes
        render conn, :new, changeset: changeset, parent_nodes: parent_nodes
    end
  end

  def show(conn, %{"id" => id}) do
    topic =
      id
      |> Topics.get_topic!
      |> Topic.preload_all

    render conn, :show, topic: topic
  end
end
