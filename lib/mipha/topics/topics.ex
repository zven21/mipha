defmodule Mipha.Topics do
  @moduledoc """
  The Topics context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias Mipha.{
    Repo,
    Accounts,
    Notifications
  }

  alias Mipha.Topics.Topic
  alias Accounts.User
  alias Mipha.Follows.Follow

  @username_regex ~r{@([A-Za-z0-9]+)}

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Topic
    |> Repo.all()
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
    |> Repo.preload([:node, :user, :last_reply_user, [replies: [:user, [parent: :user]]]])
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  @spec change_topic(Topic.t()) :: Ecto.Changeset.t()
  def change_topic(%Topic{} = topic \\ %Topic{}), do: Topic.changeset(topic, %{})

  @doc """
  Increment topic visit count.
  """
  def topic_visit_counter(%Topic{} = topic), do: Topic.counter(topic, :inc, :visit_count)

  @doc """
  Inserts a topic.

  ## Examples

      iex> insert_topic(%User{}, %{field: value})
      {:ok, %Topic{}}

      iex> insert_topic(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec insert_topic(User.t(), map()) :: {:ok, Topic.t()} | {:error, Ecto.Changeset.t()}
  def insert_topic(user, attrs \\ %{}) do
    attrs = attrs |> Map.put("user_id", user.id)
    topic_changeset = Topic.changeset(%Topic{}, attrs)

    Multi.new()
    |> Multi.insert(:topic, topic_changeset)
    |> maybe_notify_users_of_new_topic()
    |> maybe_notify_mention_users_of_new_topic(attrs)
    |> Repo.transaction()
  end

  defp maybe_notify_users_of_new_topic(multi) do
    insert_notification_fn = fn %{topic: topic} ->
      # 获取关注话题作者的 follower.
      notified_users = notifiable_users_of_topic(topic)

      attrs = %{
        actor_id: topic.user_id,
        action: "topic_added",
        topic_id: topic.id,
        notified_users: notified_users
      }

      case Notifications.insert_notification(attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notify_users_of_new_topic, insert_notification_fn)
  end

  # 通知被 @ 的用户
  def maybe_notify_mention_users_of_new_topic(multi, attrs) do
    insert_notification_fn = fn %{topic: topic} ->
      notified_users =
        @username_regex
        |> Regex.scan(attrs["body"])
        |> Enum.map(fn([_, match]) -> Accounts.get_user_by_username(match) end)
        |> Enum.filter(&(not is_nil(&1)))

      attrs = %{
        actor_id: topic.user_id,
        action: "topic_mentioned",
        topic_id: topic.id,
        notified_users: notified_users
      }

      case Notifications.insert_notification(attrs) do
        {:ok, %{notification: notification}} -> {:ok, notification}
        {:error, _, reason, _} -> {:error, reason}
      end
    end

    Multi.run(multi, :notify_mention_users_of_new_topic, insert_notification_fn)
  end

  # 获取关注话题作者的 follower.
  def notifiable_users_of_topic(%Topic{} = topic) do
    query =
      from u in User,
        join: f in Follow,
        on: f.follower_id == u.id,
        where: f.user_id == ^topic.user_id

    Repo.all(query)
  end

  @doc """
  Returns the featured of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_featured_topics do
    Topic.featured
    |> Repo.all()
    |> Repo.preload([:node, :user, :last_reply_user])
  end

  @doc """
  Return topic count of a owner(user).
  """
  @spec get_topic_count(User.t()) :: non_neg_integer()
  def get_topic_count(%User{} = user) do
    Topic
    |> Topic.by_user(user)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  获取全部 topic 个数
  """
  @spec get_total_topic_count :: non_neg_integer()
  def get_total_topic_count do
    Topic
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Return the recent of topics.
  """
  @spec recent_topics(User.t()) :: [Topic.t()] | nil
  def recent_topics(%User{} = user) do
    user
    |> Topic.by_user
    |> Topic.recent
    |> Repo.all
    |> Repo.preload([:node, :user, :last_reply_user])
  end

  @doc """
  获取话题作者

  ## Example

      iex> author(%Topic{})
      %User{}

  """
  @spec author(Topic.t()) :: User.t()
  def author(%Topic{} = topic) do
    topic
    |> Topic.preload_user
    |> Map.fetch!(:user)
  end

  alias Mipha.Topics.Node

  @doc """
  Returns the list of nodes.

  ## Examples

      iex> list_nodes()
      [%Node{}, ...]

  """
  def list_nodes do
    Repo.all(Node)
  end

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id), do: Repo.get!(Node, id)

  @doc """
  Creates a node.

  ## Examples

      iex> create_node(%{field: value})
      {:ok, %Node{}}

      iex> create_node(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node.

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{source: %Node{}}

  """
  @spec change_node(Node.t()) :: Ecto.Changeset.t()
  def change_node(%Node{} = node \\ %Node{}), do: Node.changeset(node, %{})

  @doc """
  Returns the parent of nodes
  """
  @spec list_parent_nodes :: [Node.t()] | nil
  def list_parent_nodes do
    Node.is_parent
    |> Repo.all
    |> Node.preload_children
  end
end
