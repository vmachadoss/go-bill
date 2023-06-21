defmodule GoBillManager.Repo.Migrations.AddEmployeesTable do
  use Ecto.Migration

  def change do
    create table(:employees, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :role, :string, null: false

      timestamps(updated_at: false)
    end
  end
end
