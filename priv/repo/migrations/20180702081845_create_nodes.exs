defmodule Mipha.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add(:name, :string)
      add(:summary, :string)
      add(:position, :integer)
      add(:parent_id, :integer)

      timestamps()
    end
  end
end
