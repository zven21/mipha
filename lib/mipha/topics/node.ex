defmodule Mipha.Topics.Node do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

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
