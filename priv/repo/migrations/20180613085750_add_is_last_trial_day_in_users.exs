defmodule Ptx.Repo.Migrations.AddIsLastTrialDayInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :expiring_tomorrow, :boolean, default: false
    end
  end
end
