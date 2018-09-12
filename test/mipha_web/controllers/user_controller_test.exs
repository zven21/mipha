defmodule MiphaWeb.UserControllerTest do
  use MiphaWeb.ConnCase

  import Mipha.Follows, only: [has_followed?: 1]

  test "lists active users", %{conn: conn} do
    u1 = insert(:user)
    u2 = insert(:user)
    conn = get(conn, user_path(conn, :index))

    assert conn.status == 200
    assert conn.resp_body =~ u1.username
    assert conn.resp_body =~ u2.username
  end

  # test "renders single user dashboard", %{conn: conn} do
  #   u1 = insert(:user)
  #   conn = get(conn, user_path(conn, :show, u1.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ u1.username
  # end

  # test "renders user topic lists", %{conn: conn} do
  #   t = insert(:topic)
  #   conn = get(conn, user_topics_path(conn, :topics, t.user.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ t.title
  # end

  # test "renders user reply lists", %{conn: conn} do
  #   r = insert(:reply)
  #   conn = get(conn, user_replies_path(conn, :replies, r.user.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ r.content
  # end

  # test "renders user followers user lists", %{conn: conn} do
  #   f = insert(:follow)
  #   conn = get(conn, user_followers_path(conn, :followers, f.user.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ f.follower.username
  # end

  # test "renders user following user lists", %{conn: conn} do
  #   f = insert(:follow)
  #   conn = get(conn, user_following_path(conn, :following, f.follower.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ f.user.username
  # end

  # test "renders user collection lists", %{conn: conn} do
  #   c = insert(:collection)
  #   conn = get(conn, user_collections_path(conn, :collections, c.user.username))

  #   assert conn.status == 200
  #   assert conn.resp_body =~ c.topic.title
  # end

  @tag :as_user
  test "follows user", %{conn: conn, user: user} do
    u = insert(:user)
    conn = post(conn, user_follow_path(conn, :follow, u.username))

    assert redirected_to(conn) == user_path(conn, :show, u.username)
    assert has_followed?(user: u, follower: user) == true
  end

  @tag :as_user
  test "unfollows user", %{conn: conn, user: user} do
    u = insert(:user)
    _follow = insert(:follow, follower: user, user: u)
    conn = post(conn, user_unfollow_path(conn, :unfollow, u.username))

    assert redirected_to(conn) == user_path(conn, :show, u.username)
    assert has_followed?(user: u, follower: user) == false
  end
end
