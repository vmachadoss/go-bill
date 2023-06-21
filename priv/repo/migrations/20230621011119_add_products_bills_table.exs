defmodule GoBillManager.Repo.Migrations.AddProductsBillsTable do
  use Ecto.Migration

  def change do
    create table(:products_bills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :product_id, references(:products, name: :products_id_fk, type: :uuid), null: false
      add :bill_id, references(:bills, name: :bills_id_fk, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:products_bills, [:product_id, :bill_id],
             name: :products_bills_unique_index
           )
  end
end
