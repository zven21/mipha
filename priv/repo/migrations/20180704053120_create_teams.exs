defmodule Mipha.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add(:owner_id, :integer)
      add(:github_handle, :string)
      add(:name, :string)
      add(:summary, :string)
      add(:avatar, :string)
      add(:email, :string)
      add(:email_public, :boolean)
      add(:twitter_handle, :string)
      add(:slug, :string)
      add(:website, :string)

      timestamps()
    end
  end
end
