defmodule GoBillManager.Repo.Migrations.AddProductsBillsTable do
  use Ecto.Migration

  def change do
    create table(:products_bills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :product_id, references(:products, type: :uuid), null: false
      add :bill_id, references(:bills, type: :uuid), null: false

      timestamps()
    end
  end
end
