defmodule Ptx.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :data, :map
      add :transaction_id, references(:transactions, on_delete: :delete_all, type: :string)
      timestamps()
    end

    create index(:tickets, [:transaction_id])
  end
end
