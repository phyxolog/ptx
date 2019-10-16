defmodule Ptx.Repo.Migrations.AddOrderToFaqs do
  use Ecto.Migration

  def change do
    alter table(:faqs) do
      add :order, :integer, default: 0
    end
  end
end
