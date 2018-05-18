defmodule Ptx.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :id, :string
      add :subject, :string
      add :recipients, {:array, :string}
      add :recipients_clear, {:array, :string}
      add :sender_id, references(:users, on_delete: :nothing)
      add :thread_id, references(:threads, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:thread_id])
  end
end
