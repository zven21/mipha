defmodule Mipha.Topics.Topic do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :body, :string
    field :closed_at, :naive_datetime
    field :last_reply_id, :integer
    field :last_reply_user_id, :integer
    field :node_id, :integer
    field :replied_at, :naive_datetime
    field :reply_count, :integer
    field :suggested_at, :naive_datetime
    field :title, :string
    field :type, :string
    field :user_id, :integer
    field :visit_count, :integer

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    permitted_attrs = ~w(
      title
      body
      closed_at
      user_id
      type
      node_id
      visit_count
      reply_count
      last_reply_id
      last_reply_user_id
      replied_at
      suggested_at
    )a

    required_attrs = ~w(
      title
      body
      node_id
      user_id
    )a

    topic
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
