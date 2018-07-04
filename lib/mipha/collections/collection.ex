defmodule Mipha.Collections.Collection do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mipha.{
    Repo,
    Topics,
    Accounts,
    Collections
  }

  alias Accounts.User
  alias Topics.Topic
  alias Collections.Collection

  @type t :: %Collection{}

  schema "collections" do
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

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
