defmodule Ptx.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :string, primary_key: true
      add :plan, :string, default: nil, null: false
      add :periodicity, :string, null: false
      add :amount, :decimal, precision: 19, scale: 6, null: false
      add :status, :string, default: "pending", null: false
      add :period, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :string), null: false
      timestamps()
    end

    alter table(:transactions) do
      modify :user_id, :string, size: 320
    end

    create index(:transactions, [:user_id])
    create constraint(:transactions, :plan, check: "plan in ('basic', 'pro')")
    create constraint(:transactions, :periodicity, check: "periodicity in ('month', 'year')")
    create constraint(:transactions, :status, check: "status in ('pending', 'sandbox', 'subscribed', 'success', 'unsubscribed', 'wait_unsubscribe', 'error', 'failure')")
  end
end
