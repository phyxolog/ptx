defmodule Ptx.Repo.Migrations.AddInSubscription do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :in_subscription, :string, default: nil, null: true
    end
  end
end
