defmodule Mipha.Replies.Reply do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mipha.{
    Topics.Topic,
    Replies.Reply,
    Accounts.User
  }

  @type t :: %Reply{}

  schema "repies" do
    field :content, :string

    belongs_to :user, User
    belongs_to :topic, Topic
    belongs_to :parent, Reply, foreign_key: :parent_id

    has_many :children, Reply, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:topic_id, :user_id, :parent_id, :content])
    |> validate_required([:topic_id, :user_id, :parent_id, :content])
  end
end
