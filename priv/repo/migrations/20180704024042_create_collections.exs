defmodule Mipha.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :user_id, :integer
      add :topic_id, :integer

      timestamps()
    end

  end
end
