defmodule Mipha.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :email_public, :boolean
      add :password_hash, :string
      add :avatar, :string
      add :bio, :string
      add :tagline, :string
      add :website, :string
      add :github_handle, :string
      add :is_admin, :boolean, default: false, null: false
      add :location_id, :integer
      add :company_id, :integer
      add :wechat, :string
      add :alipay, :string
      add :locked_at, :naive_datetime

      timestamps()
    end

  end
end
