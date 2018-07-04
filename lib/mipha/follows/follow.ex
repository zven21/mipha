defmodule Mipha.Follows.Follow do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Mipha.{
    Repo,
    Accounts.User,
    Follows.Follow
  }

  @type t :: %Follow{}

  schema "follows" do
    belongs_to :user, User
    belongs_to :follower, User, foreign_key: :follower_id

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    permitted_attrs = ~w(
      user_id
      follower_id
    )a

    required_attrs = ~w(
      user_id
      follower_id
    )

    follow
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
