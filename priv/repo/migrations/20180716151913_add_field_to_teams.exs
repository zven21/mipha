defmodule Mipha.Repo.Migrations.AddFieldToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :email, :string
      add :email_public, :boolean
      add :twitter_handle, :string
      add :slug, :string
      add :website, :string
    end
  end
end
