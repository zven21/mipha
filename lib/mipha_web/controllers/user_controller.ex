defmodule MiphaWeb.UserController do
  use MiphaWeb, :controller

  alias Mipha.{
    Repo,
    Mailer,
    Accounts,
    Topics,
    Replies,
    Follows,
    Collections,
    Token
  }

  alias MiphaWeb.Email
  alias Accounts.User

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
    page =
      [user: user]
      |> Topics.cond_topics()
      |> Repo.paginate(conn.params)

    render conn, :topics,
      user: user,
      page: page,
      topics: page.entries
  end

  def replies(conn, _params, user) do
    page =
      [user: user]
      |> Replies.cond_replies()
      |> Repo.paginate(conn.params)

    render conn, :replies,
      user: user,
      page: page,
      replies: page.entries
  end

  def following(conn, _params, user) do
    page =
      [follower: user]
      |> Follows.cond_follows()
      |> Repo.paginate(conn.params)

    render conn, :following,
      user: user,
      page: page,
      following: page.entries
  end

  def followers(conn, _params, user) do
    page =
      [user: user]
      |> Follows.cond_follows()
      |> Repo.paginate(conn.params)

    render conn, :followers,
      user: user,
      page: page,
      followers: page.entries
  end

  def collections(conn, _params, user) do
    page =
      [user: user]
      |> Collections.cond_collections()
      |> Repo.paginate(conn.params)

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

      {:error, %Ecto.Changeset{}} ->
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

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:danger, "Unfollow error.")
        |> redirect(to: user_path(conn, :show, user.username))

      {:error, reason} ->
        conn
        |> put_flash(:danger, reason)
        |> redirect(to: user_path(conn, :show, user.username))
    end
  end

  def sent_forgot_password_email(conn, %{"user" => user_params}) do
    with {:ok, email} <- parse(user_params["email"]),
         {:ok, user} <- parse(Accounts.get_user_by_email(email))
    do
      # Send email
      user
      |> Token.generate_token()
      |> Email.forgot_password(user)
      |> Mailer.deliver_later()

      conn
      |> put_flash(:success, "稍后，您将收到重置密码的电子邮件。")
      |> redirect(to: "/")
    else
      _ ->
        conn
        |> put_flash(:danger, "The email is invalid.")
        |> redirect(to: "/forgot_password")
    end
  end

  def forgot_password(conn, _) do
    render conn, :forgot_password
  end

  def reset_password(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token) do
      user = Accounts.get_user!(user_id)
      changeset = User.reset_password_changeset(user, %{})

      render conn, :reset_password,
        user: user,
        token: token,
        changeset: changeset
    else
      _ -> render conn, :invalid_token
    end
  end

  def reset_password(conn, _) do
    conn
    |> put_flash(:danger, "The verification link is invalid.")
    |> redirect(to: "/")
  end

  def update_password(conn, %{"user" => user_params}) do
    with {:ok, token} <- parse(user_params["reset_password_token"]),
         {:ok, user_id} <- Token.verify_token(token)
    do
      user = Accounts.get_user!(user_id)
      case Accounts.update_reset_password(user, user_params) do
        {:ok, _} ->
          conn
          |> put_flash(:success, "reset password successfully.")
          |> redirect(to: "/login")

        {:error, %Ecto.Changeset{} = changeset} ->
          render conn, :reset_password,
            changeset: changeset,
            user: user,
            token: token
      end
    else
      _ -> render conn, :invalid_token
    end
  end

  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token),
         %User{email_verified_at: nil} = user <- Accounts.get_user!(user_id)
    do
      Accounts.mark_as_verified(user)
      render conn, :verified
    else
      _ -> render conn, :invalid_token
    end
  end

  def verify_email(conn, _) do
    conn
    |> put_flash(:danger, "The verification link is invalid.")
    |> redirect(to: "/")
  end

  defp parse(nil), do: {:error, "nil"}
  defp parse(valid), do: {:ok, valid}
end
