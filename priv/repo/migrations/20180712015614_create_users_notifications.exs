defmodule Mipha.Repo.Migrations.CreateUsersNotifications do
  use Ecto.Migration

  def change do
    create table(:users_notifications) do
      add :user_id, :integer
      add :notification_id, :integer
      add :read_at, :naive_datetime

      timestamps()
    end

  end
end
