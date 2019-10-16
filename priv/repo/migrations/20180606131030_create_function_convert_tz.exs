defmodule Ptx.Repo.Migrations.CreateFunctionConvertTz do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION convert_tz(datetime timestamp, timezone text) RETURNS timestamp without time zone AS $$
      BEGIN
        RETURN ((datetime) AT TIME ZONE 'UTC') AT TIME ZONE timezone;
      END;
      $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute "DROP FUNCTION IF EXISTS convert_tz(timestamp, text);"
  end
end
