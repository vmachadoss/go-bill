defmodule GoBillManager.Repo.Migrations.AddCustomerTablesTable do
  use Ecto.Migration

  def change do
    create table(:customer_tables, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :label, :string
      add :state, :string, null: false

      timestamps(updated_at: false)
    end
  end
end
