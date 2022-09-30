defmodule GoBillManager.Repo.Migrations.AddBillTable do
  use Ecto.Migration

  def change do
    create table(:bill, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :float, null: false
      add :consumables, :map, null: false
      add :status, :string, null: false
      add :employee_id, references(:employee, type: :uuid, on_delete: :delete_all), null: false
      add :board_id, references(:board, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
