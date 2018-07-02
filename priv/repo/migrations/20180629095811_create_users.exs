defmodule Mipha.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :avatar, :string
      add :bio, :string
      add :website, :string
      add :github_handle, :string
      add :is_admin, :boolean, default: false, null: false

      timestamps()
    end

  end
end
