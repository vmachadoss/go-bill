defmodule GoBillManager.Repo.Migrations.AddProductsTable do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :retail_price, :integer
      add :description, :text

      timestamps()
    end
  end
end
