defmodule Mipha.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :owner_id, :integer
      add :github_handle, :string
      add :name, :string
      add :summary, :string
      add :avatar, :string

      timestamps()
    end

  end
end
