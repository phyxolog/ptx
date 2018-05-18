defmodule Ptx.Repo.Migrations.CreateMessageLinks do
  use Ecto.Migration

  def change do
    create table(:message_links, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :url, :text
      add :text, :text
      add :clicks_count, :bigint, default: 0
      add :message_id, references(:messages, type: :string, on_delete: :delete_all)

      timestamps()
    end

    create index(:message_links, [:message_id])
  end
end
