defmodule Mipha.Accounts.UserTeam do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum, only: [defenum: 3]

  alias Mipha.Accounts.{User, Team}

  defenum UTRole, :ut_role, [
    :owner,
    :member
  ]

  defenum UTStatus, :ut_status, [
    :pending,
    :accepted,
    :refused
  ]

  schema "users_teams" do
    field :role, UTRole
    field :status, UTStatus

    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

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
