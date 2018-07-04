defmodule Mipha.Repo.Migrations.CreateStars do
  use Ecto.Migration

  def change do
    create table(:stars) do
      add :user_id, :integer
      add :reply_id, :integer
      add :topic_id, :integer

      timestamps()
    end

  end
end
