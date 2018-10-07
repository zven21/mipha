defmodule MiphaWeb.UserController do
  use MiphaWeb, :controller

  alias Mipha.{Mailer, Accounts, Topics, Replies, Follows, Collections, Token}
  alias MiphaWeb.Email

  plug MiphaWeb.Plug.RequireUser when action in [:follow, :unfollow]

  def action(conn, _) do
    if conn.params["name"] do
      case Accounts.get_user_by_username(conn.params["name"]) do
        nil ->
          conn
          |> put_flash(:danger, gettext("User not exist."))
          |> redirect(to: "/")

        user ->
          apply(__MODULE__, action_name(conn), [conn, conn.params, user])
      end
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def index(conn, params) do
    users = Accounts.Queries.list_users() |> Turbo.Ecto.search(params)
    user_count = Accounts.get_user_count()

    render(conn, :index,
      users: users,
      user_count: user_count
    )
  end

  def show(conn, _params, user) do
    topics = Topics.recent_topics(user)
    replies = Replies.recent_replies(user)

    render(conn, :show,
      user: user,
      topics: topics,
      replies: replies
    )
  end

  def topics(conn, params, user) do
    result = Topics.Queries.cond_topics(user: user) |> Turbo.Ecto.turbo(params)

    render(conn, :topics,
      user: user,
      paginate: result.paginate,
      topics: result.datas
    )
  end

  def replies(conn, params, user) do
    result = Replies.Queries.cond_replies(user: user) |> Turbo.Ecto.turbo(params)

    render(conn, :replies,
      user: user,
      paginate: result.paginate,
      replies: result.datas
    )
  end

  def following(conn, params, user) do
    result = Follows.Queries.cond_follows(follower: user) |> Turbo.Ecto.turbo(params)

    render(conn, :following,
      user: user,
      paginate: result.paginate,
      following: result.datas
    )
  end

  def followers(conn, params, user) do
    result = Follows.Queries.cond_follows(user: user) |> Turbo.Ecto.turbo(params)

    render(conn, :followers,
      user: user,
      paginate: result.paginate,
      followers: result.datas
    )
  end

  def collections(conn, params, user) do
    result = Collections.Queries.cond_collections(user: user) |> Turbo.Ecto.turbo(params)

    render(conn, :collections,
      user: user,
      paginate: result.paginate,
      collections: result.datas
    )
  end

  def follow(conn, _params, user) do
    case Follows.follow_user(follower: current_user(conn), user: user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Follow successfully."))
        |> redirect(to: user_path(conn, :show, user.username))

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:danger, gettext("Follow failed."))
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
        |> put_flash(:info, gettext("Unfollow successfully."))
        |> redirect(to: user_path(conn, :show, user.username))

      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:danger, gettext("Unfollow failed."))
        |> redirect(to: user_path(conn, :show, user.username))

      {:error, reason} ->
        conn
        |> put_flash(:danger, reason)
        |> redirect(to: user_path(conn, :show, user.username))
    end
  end

  def sent_forgot_password_email(conn, %{"user" => user_params}) do
    with {:ok, email} <- parse(user_params["email"]),
         {:ok, user} <- parse(Accounts.get_user_by_email(email)) do
      # Send email
      user
      |> Token.generate_token()
      |> Email.forgot_password(user)
      |> Mailer.deliver_later()

      conn
      |> put_flash(:success, gettext("You will receive an email to reset your password."))
      |> redirect(to: "/")
    else
      _ ->
        conn
        |> put_flash(:danger, gettext("The email is invalid."))
        |> redirect(to: "/forgot_password")
    end
  end

  def forgot_password(conn, _) do
    render(conn, :forgot_password)
  end

  def reset_password(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_token(token) do
      user = Accounts.get_user!(user_id)
      changeset = Accounts.change_user_reset_password(user)

      render(conn, :reset_password,
        user: user,
        token: token,
        changeset: changeset
      )
    else
      _ -> render(conn, :invalid_token)
    end
  end

  def reset_password(conn, _) do
    conn
    |> put_flash(:danger, gettext("The verification link is invalid."))
    |> redirect(to: "/")
  end

  def update_password(conn, %{"user" => user_params}) do
    with {:ok, token} <- parse(user_params["reset_password_token"]),
         {:ok, user_id} <- Token.verify_token(token) do
      user = Accounts.get_user!(user_id)

      case Accounts.update_reset_password(user, user_params) do
        {:ok, _} ->
          conn
          |> put_flash(:success, gettext("Reset password successfully."))
          |> redirect(to: "/login")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, :reset_password,
            changeset: changeset,
            user: user,
            token: token
          )
      end
    else
      _ -> render(conn, :invalid_token)
    end
  end

  # def verify_email(conn, %{"token" => token}) do
  #   with {:ok, user_id} <- Token.verify_token(token),
  #        %User{email_verified_at: nil} = user <- Accounts.get_user!(user_id)
  #   do
  #     Accounts.mark_as_verified(user)
  #     render conn, :verified
  #   else
  #     _ -> render conn, :invalid_token
  #   end
  # end

  # def verify_email(conn, _) do
  #   conn
  #   |> put_flash(:danger, "The verification link is invalid.")
  #   |> redirect(to: "/")
  # end

  defp parse(nil), do: {:error, "nil"}
  defp parse(valid), do: {:ok, valid}
end
