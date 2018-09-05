defmodule MiphaWeb.TopicControllerTest do
  use MiphaWeb.ConnCase

  alias Mipha.Topics.Topic

  import Mipha.Stars, only: [has_starred?: 1]
  import Mipha.Collections, only: [has_collected?: 1]

  @valid_attrs %{title: "elixir mipha", body: "elixir mipha body", node_id: 1}
  @invalid_attrs %{title: nil, body: "elixir mipha body", node_id: nil}

  test "gets the topics index", %{conn: conn} do
    t1 = insert(:topic)
    t2 = insert(:topic)
    conn = get(conn, topic_path(conn, :index))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
    assert conn.resp_body =~ t2.title
  end

  test "gets the no_reply topics index", %{conn: conn} do
    t1 = insert(:topic)
    conn = get(conn, topic_path(conn, :no_reply))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  test "gets the popular topics index", %{conn: conn} do
    t1 = insert(:topic, reply_count: 15, last_reply_user: build(:user))
    conn = get(conn, topic_path(conn, :popular))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  test "gets the featured topics index", %{conn: conn} do
    t1 = insert(:topic, type: :featured)
    conn = get(conn, topic_path(conn, :featured))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  test "gets the job topics index", %{conn: conn} do
    t1 = insert(:topic, type: :job)
    conn = get(conn, topic_path(conn, :jobs))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  test "gets the single node topics index", %{conn: conn} do
    t1 = insert(:topic)
    conn = get(conn, topic_path(conn, :index, node_id: t1.node_id))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  test "gets the educational topics index", %{conn: conn} do
    t1 = insert(:topic, type: :educational)
    conn = get(conn, topic_path(conn, :educational))

    assert conn.status == 200
    assert conn.resp_body =~ t1.title
  end

  @tag :as_user
  test "stars topic", %{conn: conn, user: user} do
    t = insert(:topic, user: user)
    conn = post(conn, topic_path(conn, :star, t.id))
    topic = Repo.one(from t in Topic, where: t.id == t.id, preload: [:user])

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert has_starred?(user: topic.user, topic: topic)
  end

  @tag :as_user
  test "unstars topic", %{conn: conn, user: user} do
    t = insert(:topic, user: user)
    _star = insert(:star, topic: t, user: user)
    conn = post(conn, topic_path(conn, :unstar, t.id))
    topic = Repo.one(from t in Topic, where: t.id == t.id, preload: [:user])

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    refute has_starred?(user: topic.user, topic: topic)
  end

  @tag :as_user
  test "collections topic", %{conn: conn, user: user} do
    t = insert(:topic, user: user)
    conn = post(conn, topic_path(conn, :collection, t.id))
    topic = Repo.one(from t in Topic, where: t.id == t.id, preload: [:user])

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert has_collected?(user: topic.user, topic: topic)
  end

  @tag :as_user
  test "uncollections topic", %{conn: conn, user: user} do
    t = insert(:topic, user: user)
    _collection = insert(:collection, topic: t, user: user)
    conn = post(conn, topic_path(conn, :uncollection, t.id))
    topic = Repo.one(from t in Topic, where: t.id == t.id, preload: [:user])

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    refute has_collected?(user: topic.user, topic: topic)
  end

  @tag :as_admin
  test "suggests topic", %{conn: conn} do
    t = insert(:topic, suggested_at: nil)
    conn = post(conn, topic_path(conn, :suggest, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.suggested_at != nil
  end

  @tag :as_admin
  test "unsuggests topic", %{conn: conn} do
    t = insert(:topic, suggested_at: Timex.now())
    conn = post(conn, topic_path(conn, :unsuggest, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.suggested_at == nil
  end

  @tag :as_user
  test "closes topic", %{conn: conn} do
    t = insert(:topic, closed_at: nil)
    conn = post(conn, topic_path(conn, :close, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.closed_at != nil
  end

  @tag :as_user
  test "reopens topic", %{conn: conn} do
    t = insert(:topic, closed_at: Timex.now())
    conn = post(conn, topic_path(conn, :open, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.closed_at == nil
  end

  @tag :as_admin
  test "makes featured topic with admin", %{conn: conn} do
    t = insert(:topic, type: :normal)
    conn = post(conn, topic_path(conn, :excellent, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.type == :featured
  end

  @tag :as_admin
  test "makes normal topic with admin", %{conn: conn} do
    t = insert(:topic, type: :featured)
    conn = post(conn, topic_path(conn, :normal, t.id))
    topic = Repo.one(from t in Topic, where: t.id == ^t.id)

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.type == :normal
  end

  @tag :as_user
  test "updates topic and redirects", %{conn: conn} do
    t = insert(:topic)
    conn = put(conn, topic_path(conn, :update, t.id), topic: @valid_attrs)

    assert redirected_to(conn) == topic_path(conn, :show, t.id)
    assert count(Topic) == 1
  end

  @tag :as_user
  test "renders form to create new topic", %{conn: conn} do
    conn = get(conn, topic_path(conn, :new))
    assert html_response(conn, 200) =~ ~r/new/
  end

  @tag :as_user
  test "renders form to create edit topic", %{conn: conn} do
    t = insert(:topic)
    conn = get(conn, topic_path(conn, :edit, t.id))

    assert html_response(conn, 200) =~ ~r/edit/
  end

  @tag :as_user
  test "creates topic with valid attributes, and redirectes", %{conn: conn} do
    conn = post(conn, topic_path(conn, :create), topic: @valid_attrs)
    topic = Repo.one(from t in Topic, where: t.title == ^@valid_attrs[:title])

    assert redirected_to(conn) == topic_path(conn, :show, topic.id)
    assert topic.title == @valid_attrs[:title]
  end

  @tag :as_user
  test "does not create topic with invalid attributes", %{conn: conn} do
    count_before = count(Topic)
    conn = post(conn, topic_path(conn, :create), topic: @invalid_attrs)

    assert conn.status == 200
    assert count(Topic) == count_before
  end

  test "gets a topic show page", %{conn: conn} do
    t = insert(:topic)
    conn = get(conn, topic_path(conn, :show, t.id))

    assert html_response(conn, 200) =~ t.title
  end

  # test "getting a topic page that doesn't exist", %{conn: conn} do
  #   assert_raise Ecto.NoResultsError, fn ->
  #     get conn, topic_path(conn, :show, "bad-id")
  #   end
  # end

  test "requires user auth on any acitons", %{conn: conn} do
    t = insert(:topic)

    Enum.each([
      get(conn, topic_path(conn, :new)),
      post(conn, topic_path(conn, :create), topic: @valid_attrs),
      get(conn, topic_path(conn, :edit, t.id)),
      put(conn, topic_path(conn, :update, t.id), topic: @valid_attrs),
      delete(conn, topic_path(conn, :delete, t.id)),
    ], fn conn ->
      assert html_response(conn, 302)
    end)
  end

  @tag :as_user
  test "requires admin auth on any acitons", %{conn: conn} do
    t = insert(:topic)

    Enum.each([
      post(conn, topic_path(conn, :unsuggest, t.id)),
      post(conn, topic_path(conn, :suggest, t.id)),
      post(conn, topic_path(conn, :normal, t.id)),
      post(conn, topic_path(conn, :excellent, t.id))
    ], fn conn ->
      assert html_response(conn, 302)
    end)
  end
end
