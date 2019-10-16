defmodule Ptx.Repo.Migrations.AddUnsubscribeFlagToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :in_unsubscribe_process, :boolean, default: false
    end
  end
end
