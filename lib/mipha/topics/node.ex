defmodule Mipha.Topics.Node do
  @moduledoc false
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Mipha.{
    Repo,
    Topics
  }

  alias Topics.{Topic, Node}

  @type t :: %Node{}

  schema "nodes" do
    field :name, :string
    field :position, :integer
    field :summary, :string

    belongs_to :parent, Node, foreign_key: :parent_id

    has_many :topics, Topic
    has_many :children, Node, foreign_key: :parent_id

    timestamps()
  end

  @doc """
  Returns the children node.
  """
  @spec is_child(Ecto.Queryable.t()) :: Ecto.Query.t()
  def is_child(query \\ __MODULE__), do: from(q in query, where: not is_nil(q.parent_id))

  @doc """
  Returns the parent of node.
  """
  @spec is_parent(Ecto.Queryable.t()) :: Ecto.Query.t()
  def is_parent(query \\ __MODULE__), do: from(q in query, where: is_nil(q.parent_id))

  @doc """
  Preloads the children of a node.
  """
  @spec preload_children(t()) :: t()
  def preload_children(node), do: Repo.preload(node, :children)

  @doc false
  def changeset(node, attrs) do
    permitted_attrs = ~w(
      name
      summary
      position
      parent_id
    )a

    required_attrs = ~w(
      name
    )a

    node
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
