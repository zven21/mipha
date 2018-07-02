defmodule Mipha.Topics.Node do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :name, :string
    field :parent_id, :integer
    field :position, :integer
    field :summary, :string

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:name, :summary, :position, :parent_id])
    |> validate_required([:name, :summary, :position, :parent_id])
  end
end
