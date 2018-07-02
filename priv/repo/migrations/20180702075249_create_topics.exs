defmodule Mipha.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string
      add :body, :text
      add :closed_at, :naive_datetime
      add :user_id, :integer
      add :type, :string
      add :node_id, :integer
      add :visit_count, :integer
      add :reply_count, :integer
      add :last_reply_id, :integer
      add :last_reply_user_id, :integer
      add :replied_at, :naive_datetime
      add :suggested_at, :naive_datetime

      timestamps()
    end

  end
end
