defmodule Mipha.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :action, :string
      add :actor_id, :integer
      add :reply_id, :integer
      add :user_id, :integer
      add :topic_id, :integer

      timestamps()
    end

  end
end
