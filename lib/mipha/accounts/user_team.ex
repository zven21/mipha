defmodule Mipha.Accounts.UserTeam do
  @moduledoc false

  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import EctoEnum, only: [defenum: 3]

  alias Mipha.Accounts.{User, Team}

  defenum UTRole, :ut_role, [
    :owner,
    :member
  ]

  defenum UTStatus, :ut_status, [
    :pending,
    :accepted,
    :rejected
  ]

  schema "users_teams" do
    field :role, UTRole
    field :status, UTStatus

    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

  @doc """
  Filters the user of user_teams.
  """
  @spec by_user(Ecto.Queryable.t(), User.t()) :: Ecto.Query.t()
  def by_user(query \\ __MODULE__, %User{id: user_id}),
    do: where(query, [..., ut], ut.user_id == ^user_id)

  @doc """
  Filters the team of user_teams.
  """
  @spec by_team(Ecto.Queryable.t(), Team.t()) :: Ecto.Query.t()
  def by_team(query \\ __MODULE__, %Team{id: team_id}),
    do: where(query, [..., ut], ut.team_id == ^team_id)

  @doc """
  Changeset
  """
  def changeset(user_team, attrs) do
    permitted_attrs = ~w(
      user_id
      team_id
      role
      status
    )a

    required_attrs = ~w(
      user_id
      team_id
      role
      status
    )a

    user_team
    |> cast(attrs, permitted_attrs)
    |> validate_required(required_attrs)
  end
end
