defmodule Mipha.Accounts.Team do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Mipha.Accounts.{User, Team, UserTeam}

  @type t :: %Team{}

  schema "teams" do
    field :name, :string
    field :slug, :string
    field :avatar, :string
    field :summary, :string
    field :website, :string
    field :github_handle, :string
    field :twitter_handle, :string
    field :email, :string
    field :email_public, :boolean

    belongs_to :owner, User

    many_to_many :users, User, join_through: UserTeam

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:owner_id, :github_handle, :name, :summary, :avatar])
    |> validate_required([:owner_id, :github_handle, :name, :summary, :avatar])
  end
end
