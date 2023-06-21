defmodule GoBillManager.Repo.Migrations.AddCustomersTable do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      add :bill_id, references(:bills, type: :uuid), null: false
      add :customer_table_id, references(:customer_tables, type: :uuid), null: false

      timestamps(updated_at: false)
    end
  end
end
