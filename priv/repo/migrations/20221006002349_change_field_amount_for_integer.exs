defmodule GoBillManager.Repo.Migrations.ChangeFieldAmountForInteger do
  use Ecto.Migration

  def change do
    alter table(:bill) do
      modify(:amount, :integer)
    end
  end
end
