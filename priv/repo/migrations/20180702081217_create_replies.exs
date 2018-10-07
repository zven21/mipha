defmodule Mipha.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add(:topic_id, :integer)
      add(:user_id, :integer)
      add(:parent_id, :integer)
      add(:content, :text)
      add(:star_count, :integer)

      timestamps()
    end
  end
end
