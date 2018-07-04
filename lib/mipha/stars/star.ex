defmodule Mipha.Stars.Star do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mipha.{
    Repo,
    Topics.Topic,
    Replies.Reply,
    Accounts.User,
    Stars.Star
  }

  schema "stars" do
    belongs_to :reply, Reply
    belongs_to :user, User
    belongs_to :topic, Topic

    timestamps()
  end

  @doc false
  def changeset(star, attrs) do
    permitted_attrs = ~w(
      user_id
      reply_id
      topic_id
    )a

    required_attrs = ~w(
      user_id
    )a

    star
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
