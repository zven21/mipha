defmodule MiphaWeb.TopicController do
  use MiphaWeb, :controller

  alias Mipha.{Topics, Stars, Collections, Markdown}
  alias Mipha.Topics.Queries

  plug MiphaWeb.Plug.RequireUser when action in ~w(
    new create edit update
    star unstar collection uncollection
    unsuggest suggest close open excellent normal
  )a

  @intercepted_action ~w(index no_reply popular featured educational)a

  def action(conn, _) do
    conn
    |> action_name
    |> do_fragment(conn)
  end

  defp do_fragment(action_name, conn) when action_name in @intercepted_action do
    opts =
      if conn.params["node_id"] do
        [node: Topics.get_node!(conn.params["node_id"])]
      else
        [type: action_name(conn)]
      end

    parent_nodes = Topics.list_parent_nodes
    result =
      opts
      |> Queries.cond_topics
      |> Turbo.Ecto.turbo(conn.params)

    render conn, action_name(conn),
      asset: "topics",
      topics: result.datas,
      paginate: result.paginate,
      parent_nodes: parent_nodes
  end
  defp do_fragment(:suggest, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"suggested_at" => Timex.now}
    flash = gettext("Pin")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(:unsuggest, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"suggested_at" => nil}
    flash = gettext("Unpin")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(:close, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"closed_at" => Timex.now}
    flash = gettext("Closed")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(:open, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"closed_at" => nil}
    flash = gettext("Opened")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(:excellent, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"type" => "featured"}
    flash = gettext("Featured topic")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(:normal, conn) do
    topic = Topics.get_topic!(conn.params["id"])
    attrs = %{"type" => "normal"}
    flash = gettext("Normal topic")

    do_update(conn, topic, attrs, flash)
  end
  defp do_fragment(_, conn) do
    apply(__MODULE__, action_name(conn), [conn, conn.params])
  end

  # update topic
  defp do_update(conn, topic, attrs, flash) do
    {:ok, topic} = Topics.update_topic(topic, attrs)

    conn
    |> put_flash(:success, flash)
    |> redirect(to: topic_path(conn, :show, topic))
  end

  def jobs(conn, params) do
    parent_nodes = Topics.list_parent_nodes
    result = Turbo.Ecto.turbo(Queries.job_topics, params)

    render conn, :jobs,
      parent_nodes: parent_nodes,
      topics: result.datas,
      paginate: result.paginate
  end

  def new(conn, _params) do
    changeset = Topics.change_topic()
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
    case Topics.insert_topic(current_user(conn), topic_params) do
      {:ok, %{topic: topic}} ->
        conn
        |> put_flash(:success, gettext("Topic created successfully."))
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, :topic, %Ecto.Changeset{} = changeset, _} ->
        parent_nodes = Topics.list_parent_nodes
        conn
        |> put_flash(:danger, gettext("Create topic failed, pls select node_id."))
        |> render(:new, changeset: changeset, parent_nodes: parent_nodes)
    end
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Topics.get_topic!(id)
    case Topics.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:success, gettext("Topic updated successfully."))
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, %Ecto.Changeset{} = changeset} ->
        parent_nodes = Topics.list_parent_nodes
        render conn, :edit, topic: topic, changeset: changeset, parent_nodes: parent_nodes
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)

    # Same session, same visit counter.
    if is_nil(get_session(conn, "visited_topic_#{topic.id}")) do
      # increment topic visit count.
      Topics.topic_visit_counter(topic)
      conn
      |> put_session("visited_topic_#{topic.id}", topic.id)
      |> render(:show, topic: topic)
    else
      render(conn, :show, topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    {:ok, _topic} = Topics.delete_topic(topic)

    conn
    |> put_flash(:info, gettext("Topic deleted successfully."))
    |> redirect(to: topic_path(conn, :index))
  end

  def preview(conn, %{"body" => body}) do
    json(conn, %{body: Markdown.render(body)})
  end

  def star(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    attrs = %{
      user_id: current_user(conn).id,
      topic_id: topic.id
    }
    case Stars.insert_star(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Star successfully"))
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:danger, gettext("Star failed"))
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def unstar(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    attrs = [
      user_id: current_user(conn).id,
      topic_id: topic.id
    ]
    case Stars.delete_star(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Unstar successfully"))
        |> redirect(to: topic_path(conn, :show, topic))
      {:error, _} ->
        conn
        |> put_flash(:danger, gettext("Unstar failed"))
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def collection(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    attrs = %{
      user_id: current_user(conn).id,
      topic_id: topic.id
    }
    case Collections.insert_collection(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Collection successfully"))
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:danger, gettext("Collection failed"))
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def uncollection(conn, %{"id" => id}) do
    topic = Topics.get_topic!(id)
    attrs = [
      user_id: current_user(conn).id,
      topic_id: topic.id
    ]
    case Collections.delete_collection(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Uncollection successfully"))
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:danger, gettext("Uncollection failed"))
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end
end
