defmodule Mipha.Replies.Reply do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "repies" do
    field :content, :string
    field :parent_id, :integer
    field :topic_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:topic_id, :user_id, :parent_id, :content])
    |> validate_required([:topic_id, :user_id, :parent_id, :content])
  end
end
