defmodule Mipha.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add(:user_id, :integer)
      add(:follower_id, :integer)

      timestamps()
    end

    create(unique_index(:follows, [:follower_id, :user_id]))
  end
end
