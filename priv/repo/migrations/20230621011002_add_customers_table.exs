defmodule GoBillManager.Repo.Migrations.AddCustomersTable do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      add :bill_id, references(:bills, name: :bills_id_fk, type: :uuid), null: false

      add :customer_table_id,
          references(:customer_tables, name: :customers_table_id_fk, type: :uuid)

      timestamps(updated_at: false)
    end

    create unique_index(:customers, [:bill_id], name: :customers_bill_unique_index)
  end
end
