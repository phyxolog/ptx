defmodule Ptx.Repo.Migrations.CreateEmailReadList do
  use Ecto.Migration

  def change do
    create table(:email_read_list) do
      add :recepient, :string, default: nil, size: 1000
      add :message_id, references(:messages, type: :string, on_delete: :delete_all)
      timestamps(updated_at: false)
    end

    create index(:email_read_list, [:message_id])
  end
end
