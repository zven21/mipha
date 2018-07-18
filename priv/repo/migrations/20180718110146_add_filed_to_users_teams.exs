defmodule Mipha.Repo.Migrations.AddFiledToUsersTeams do
  use Ecto.Migration

  def change do
    alter table(:users_teams) do
      add :status, :string
      add :role, :string
    end
  end
end
