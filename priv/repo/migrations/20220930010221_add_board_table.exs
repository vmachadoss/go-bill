defmodule GoBillManager.Repo.Migrations.AddBoardTable do
  use Ecto.Migration

  def change do
    create table(:board, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :number_of_customers, :integer, null: false
      add :status, :string, default: "occupated"

      timestamps(updated_at: false)
    end
  end
end
