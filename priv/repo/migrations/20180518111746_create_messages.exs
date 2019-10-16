defmodule Ptx.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :string, size: 1000, primary_key: true
      add :subject, :string, default: nil
      add :recipients, {:array, :string}, default: []
      add :recipients_clear, {:array, :string}, default: []
      add :readed, :boolean, default: false
      add :first_readed_at, :naive_datetime
      add :sender_id, references(:users, type: :string, on_delete: :delete_all)
      add :thread_id, references(:threads, type: :string, on_delete: :delete_all)
      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:thread_id])
  end
end
