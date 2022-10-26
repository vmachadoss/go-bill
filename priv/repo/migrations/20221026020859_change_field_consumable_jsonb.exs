defmodule GoBillManager.Repo.Migrations.ChangeFieldConsumableJsonb do
  use Ecto.Migration

  def change do
    alter table(:bill) do
      modify(:consumables, :jsonb)
    end
  end
end
