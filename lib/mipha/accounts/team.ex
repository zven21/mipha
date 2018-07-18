defmodule Mipha.Accounts.Team do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Mipha.Accounts.{User, Team, UserTeam}

  @type t :: %Team{}

  schema "teams" do
    field :name, :string
    field :avatar, :string
    field :summary, :string
    field :github_handle, :string
    field :twitter_handle, :string
    field :slug, :string
    field :website, :string
    field :email, :string
    field :email_public, :boolean

    belongs_to :owner, User
    many_to_many :team_users, User, join_through: UserTeam

    timestamps()
  end

  @doc """
  Changeset
  """
  def changeset(team, attrs) do
    permitted_attrs = ~w(
      owner_id
      name
      summary
      avatar
      slug
      website
      email
      email_public
      github_handle
      twitter_handle
    )a

    required_attrs = ~w(
      owner_id
      slug
      name
    )a

    team
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
