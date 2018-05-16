defmodule Ptx.Repo.Migrations.AddPreviousPlanToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :previous_plan, :string, default: nil, null: true
    end

    execute """
      CREATE OR REPLACE FUNCTION set_previous_plan_on_users()
      RETURNS TRIGGER AS $$
      BEGIN
        IF NEW.plan != OLD.plan THEN
          NEW.previous_plan = OLD.plan;
        END IF;
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    """

    execute "CREATE TRIGGER tgr_previous_plan_on_users BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE set_previous_plan_on_users();"
  end
end
