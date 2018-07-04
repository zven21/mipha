defmodule Mipha.Accounts.UserTeam do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Mipha.Accounts.{User, Team}

  schema "users_teams" do
    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_team, attrs) do
    user_team
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end
end
