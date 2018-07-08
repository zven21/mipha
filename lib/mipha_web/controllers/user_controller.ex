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
    user_count = Accounts.get_user_count()
    render conn, :index,
      users: users,
      user_count: user_count
  end

  def show(conn, _params, user) do
    topics = Topics.recent_topics(user)
    replies = Replies.recent_replies(user)

    render conn, :show,
      user: user,
      topics: topics,
      replies: replies
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

  def follow(conn, _params, user) do
    case Follows.follow_user(follower: current_user(conn), user: user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Follow successfully.")
        |> redirect(to: user_path(conn, :show, user.username))
      {:error, %Ecto.Changeset{}}
        conn
        |> put_flash(:danger, "Follow Error.")
        |> redirect(to: user_path(conn, :show, user.username))
      {:error, reason} ->
        conn
        |> put_flash(:danger, reason)
        |> redirect(to: user_path(conn, :show, user.username))
    end
  end

  def unfollow(conn, _params, user) do
    case Follows.unfollow_user(follower: current_user(conn), user: user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Unfollow successfully.")
        |> redirect(to: user_path(conn, :show, user.username))
      {:error, %Ecto.Changeset{}}
        conn
        |> put_flash(:danger, "Unfollow error.")
        |> redirect(to: user_path(conn, :show, user.username))
      {:error, reason} ->
        conn
        |> put_flash(:danger, reason)
        |> redirect(to: user_path(conn, :show, user.username))
    end
  end
end
