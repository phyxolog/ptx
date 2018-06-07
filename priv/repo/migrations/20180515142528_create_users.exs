defmodule Ptx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true, size: 320, null: false
      add :first_name, :string
      add :last_name, :string
      add :full_name, :string
      add :locale, :string
      add :gender, :string, default: nil, null: true
      add :picture, :string
      add :timezone, :string, default: "UTC"

      add :plan, :string, default: nil
      add :valid_until, :naive_datetime, default: nil
      add :frozen, :boolean, default: true
      add :periodicity, :string, null: true, default: nil

      add :token_type, :string
      add :access_token, :string
      add :refresh_token, :string
      add :expires_at, :integer

      timestamps()
    end

    create constraint(:users, :periodicity, check: "periodicity in ('month', 'year')")
    create constraint(:users, :plan, check: "plan in ('trial', 'basic', 'pro')")
  end
end
