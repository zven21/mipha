defmodule Mipha.Replies do
  @moduledoc """
  The Replies context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Mipha.{
    Repo,
    Topics,
    Notifications,
    Replies,
  }

  alias Replies.Reply
  alias Topics.Topic
  alias Mipha.Accounts.User
  alias Mipha.Follows.Follow

  @doc """
  Returns the list of repies.

  ## Examples

      iex> list_repies()
      [%Reply{}, ...]

  """
  def list_repies do
    Repo.all(Reply)
  end

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123)
      %Reply{}

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Creates a reply.

  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Reply.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{source: %Reply{}}

  """
  def change_reply(%Reply{} = reply) do
    Reply.changeset(reply, %{})
  end

  @doc """
  Filter the list of repies.

  ## Examples

      iex> cond_replies()
      Ecto.Query.t()

      iex> cond_replies(user: %User{})
      Ecto.Query.t()

  """
  @spec cond_replies(Keyword.t()) :: Ecto.Query.t() | nil
  def cond_replies(opts \\ []) do
    opts
    |> filter_from_clauses
    |> preload([:topic, :user])
  end

  defp filter_from_clauses(opts) do
    cond do
      Keyword.has_key?(opts, :user) -> opts |> Keyword.get(:user) |> Reply.by_user
      Keyword.has_key?(opts, :topic) -> opts |> Keyword.get(:topic) |> Reply.by_topic
      true -> Reply
    end
  end

  @doc """
  Get the reply count of a replyable.

  ## Examples

      iex> get_reply_count(user: %User{})
      10

      iex> get_reply_count(topic: %Topic{})
      2

  """
  @spec get_reply_count(Keyword.t()) :: non_neg_integer()
  def get_reply_count(clauses) do
    query =
      clauses
      |> get_replyable_from_clauses()
      |> case do
        %Topic{} = topic -> Reply.by_topic(topic)
        %Reply{} = reply -> Reply.by_parent(reply)
        %User{} = user -> Reply.by_user(user)
      end

    query
    |> join(:inner, [r], u in assoc(r, :user))
    |> Repo.aggregate(:count, :id)
  end

  defp get_replyable_from_clauses(clauses) do
    cond do
      Keyword.has_key?(clauses, :user) -> Keyword.get(clauses, :user)
      Keyword.has_key?(clauses, :topic) -> Keyword.get(clauses, :topic)
      Keyword.has_key?(clauses, :reply) -> Keyword.get(clauses, :reply)
    end
  end

  @doc """
  Return the recent of topics.
  """
  @spec recent_replies(User.t()) :: [Topic.t()] | nil
  def recent_replies(%User{} = user) do
    user
    |> Reply.by_user()
    |> Reply.recent()
    |> Repo.all()
    |> Repo.preload([:topic, :user])
  end

  @doc """
  Inserts a reply.

  ## Examples

      iex> insert_reply(%User{}, %{field: value})
      {:ok, %Reply{}}

      iex> insert_reply(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec insert_reply(User.t(), map()) :: {:ok, Reply.t()} | {:error, Ecto.Changeset.t()}
  def insert_reply(user, attrs \\ %{}) do
    attrs = attrs |> Map.put("user_id", user.id)
    reply_changeset = Reply.changeset(%Reply{}, attrs)

    Multi.new()
    |> Multi.insert(:reply, reply_changeset)
    |> update_related_topic()
    |> maybe_notify_follower_of_new_reply()
    |> notify_topic_owner_of_new_reply()
    # |> maybe_notify_parent_reply_owner_of_new_reply(attrs)
    |> Repo.transaction()
  end

  # 更新关联话题信息
  defp update_related_topic(multi) do
    update_topic_fn = fn %{reply: reply} ->
      topic =
        reply
        |> Reply.preload_topic()
        |> Map.fetch!(:topic)

      attrs = %{
        last_reply_id: reply.id,
        last_reply_user_id: reply.user_id,
        reply_count: (topic.reply_count + 1)
      }

      case Topics.update_topic(topic, attrs) do
        {:ok, topic} -> {:ok, topic}
        {:error, reason} -> {:error, reason}
      end
    end

    Multi.run(multi, :update_related_topic, update_topic_fn)
  end

  # 通知 topic 的作者
  defp notify_topic_owner_of_new_reply(multi) do
    insert_notification_fn = fn %{reply: reply} ->
      # reply -> topic -> user
      notified_users =
        reply
        |> Reply.preload_topic()
        |> Map.fetch!(:topic)
        |> Topic.preload_user()
        |> Map.fetch!(:user)

      attrs = %{
        actor_id: reply.user_id,
        action: "added",
        reply_id: reply.id,
        notified_users: [notified_users]
      }

      case Notifications.insert_notification(attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end
    Multi.run(multi, :notify_topic_owner_of_new_reply, insert_notification_fn)
  end

  # 如果是回复其他人的评论，回复该评论的作者, 有新的回复。
  defp maybe_notify_parent_reply_owner_of_new_reply(multi, %{"parent_id" => parent_id}) when not is_nil(parent_id) do
    insert_notification_fn = fn %{reply: reply} ->
      notified_users =
        reply
        |> Reply.preload_parent()
        |> Map.fetch!(:parent)
        |> Reply.preload_user()
        |> Map.fetch!(:user)

      attrs = %{
        actor_id: reply.user_id,
        action: "added",
        reply_id: reply.id,
        notified_users: [notified_users]
      }

      case Notifications.insert_notification(attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notify_parent_reply_owner_of_new_reply, insert_notification_fn)
  end
  defp maybe_notify_parent_reply_owner_of_new_reply(multi, _), do: multi

  # 发起评论时，通知关注评论作者的 follower
  defp maybe_notify_follower_of_new_reply(multi) do
    insert_notification_fn = fn %{reply: reply} ->
      # FIXME 获取关注评论作者的 follower.
      notified_users = notifiable_users_of_reply(reply)

      attrs = %{
        actor_id: reply.user_id,
        action: "added",
        reply_id: reply.id,
        notified_users: notified_users
      }

      case Notifications.insert_notification(attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notify_users_of_new_reply, insert_notification_fn)
  end

  defp notifiable_users_of_reply(%Reply{} = reply) do
    query =
      from u in User,
        join: f in Follow,
        on: f.follower_id == u.id,
        where: f.user_id == ^reply.user_id

    Repo.all(query)
  end

  @doc """
  获取评论作者

  ## Example

      iex> author(%Topic{})
      %User{}

  """
  @spec author(Reply.t()) :: User.t()
  def author(%Reply{} = reply) do
    reply
    |> Reply.preload_user()
    |> Map.fetch!(:user)
  end
end
