defmodule Ptx.Repo.Migrations.CreateLinkOpens do
  use Ecto.Migration

  def change do
    create table(:link_opens) do
      add :link_id, references(:message_links, on_delete: :delete_all, type: :binary_id)
      timestamps(updated_at: false)
    end

    create index(:link_opens, [:link_id])
  end
end
