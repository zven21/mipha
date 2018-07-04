defmodule Mipha.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :user_id, :integer
      add :follower_id, :integer

      timestamps()
    end

  end
end
