defmodule MiphaWeb.UserController do
  use MiphaWeb, :controller

  alias Mipha.{
    Repo,
    Accounts,
    Topics,
    Replies,
    Follows,
    Collections
  }

  plug MiphaWeb.Plug.RequireUser when action in [:follow, :unfollow]

  def action(conn, _) do
    if conn.params["name"] do
      user = Accounts.get_user_by_username(conn.params["name"])
      apply(__MODULE__, action_name(conn), [conn, conn.params, user])
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render conn, :index, users: users
  end

  def show(conn, _params, user) do
    render conn, :show, user: user
  end

  def topics(conn, _params, user) do
    page = Topics.cond_topics(user: user) |> Repo.paginate(conn.params)

    render conn, :topics,
      user: user,
      page: page,
      topics: page.entries
  end

  def replies(conn, _params, user) do
    page = Replies.cond_replies(user: user) |> Repo.paginate(conn.params)

    render conn, :replies,
      user: user,
      page: page,
      replies: page.entries
  end

  def following(conn, _params, user) do
    page = Follows.cond_follows(follower: user) |> Repo.paginate(conn.params)

    render conn, :following,
      user: user,
      page: page,
      following: page.entries
  end

  def followers(conn, _params, user) do
    page = Follows.cond_follows(user: user) |> Repo.paginate(conn.params)

    render conn, :followers,
      user: user,
      page: page,
      followers: page.entries
  end

  def collections(conn, _params, user) do
    page = Collections.cond_collections(user: user) |> Repo.paginate(conn.params)

    render conn, :collections,
      user: user,
      page: page,
      collections: page.entries
  end
end
