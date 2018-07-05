defmodule MiphaWeb.TopicController do
  use MiphaWeb, :controller

  alias Mipha.{Repo, Topics}
  alias Topics.Topic

  plug MiphaWeb.Plug.RequireUser when action in ~w(new create edit update)a

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

  def edit(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    changeset = Topics.change_topic(topic)
    parent_nodes = Topics.list_parent_nodes

    render conn, :edit,
      topic: topic,
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

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Topics.get_topic!(id)
    case Topics.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:success, "Topic updated successfully.")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        parent_nodes = Topics.list_parent_nodes
        render conn, :edit, topic: topic, changeset: changeset, parent_nodes: parent_nodes
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    render conn, :show, topic: topic
  end

  def delete(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    {:ok, _user} = Topics.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: topic_path(conn, :index))
  end
end
