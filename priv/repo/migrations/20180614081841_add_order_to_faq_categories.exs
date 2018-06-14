defmodule Ptx.Repo.Migrations.AddOrderToFaqCategories do
  use Ecto.Migration

  def change do
    alter table(:faq_categories) do
      add :order, :integer, default: 0
    end
  end
end
