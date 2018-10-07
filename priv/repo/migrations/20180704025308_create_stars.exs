defmodule Mipha.Repo.Migrations.CreateStars do
  use Ecto.Migration

  def change do
    create table(:stars) do
      add(:user_id, :integer)
      add(:reply_id, :integer)
      add(:topic_id, :integer)

      timestamps()
    end

    create(unique_index(:stars, [:user_id, :topic_id]))
    create(unique_index(:stars, [:user_id, :reply_id]))
  end
end
