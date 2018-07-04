defmodule Mipha.Collections.Collection do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.{
    Repo,
    Topics.Topic,
    Accounts.User,
    Collections.Collection
  }

  @type t :: %Collection{}

  schema "collections" do
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  @doc """
  Filters collection by a user.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ __MODULE__, %User{id: user_id}),
    do: where(query, [..., c], c.user_id == ^user_id)

  @doc """
  Filters collection by a topic.
  """
  @spec by_topic(Ecto.Queryable.t(), Topic.t()) :: Ecto.Query.t()
  def by_topic(query \\ __MODULE__, %Topic{id: topic_id}),
    do: where(query, [..., c], c.topic_id == ^topic_id)

  @doc false
  def changeset(collection, attrs) do
    permitted_attrs = ~w(
      user_id
      topic_id
    )a

    required_attrs = ~w(
      user_id
      topic_id
    )a

    collection
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
