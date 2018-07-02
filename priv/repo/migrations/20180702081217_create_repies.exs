defmodule Mipha.Repo.Migrations.CreateRepies do
  use Ecto.Migration

  def change do
    create table(:repies) do
      add :topic_id, :integer
      add :user_id, :integer
      add :parent_id, :integer
      add :content, :text

      timestamps()
    end

  end
end
