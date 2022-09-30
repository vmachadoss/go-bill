defmodule GoBillManager.Repo.Migrations.AddEmployeeTable do
  use Ecto.Migration

  def change do
    create table(:employee, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :role, :string, null: false, default: "attendant"

      timestamps()
    end
  end
end
