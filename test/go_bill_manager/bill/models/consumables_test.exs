defmodule GoBillManager.Bill.Models.ConsumablesTest do
  use GoBillManager.DataCase
  alias GoBillManager.Bill.Models.Consumables

  describe "changeset/2" do
    test "should return invalid changeset when missin required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Consumables.changeset(%{})

      assert %{
               consumable: ["can't be blank"],
               value: ["can't be blank"],
               quantity: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      consumables_params = %{
        consumable: 123,
        value: "invalid",
        quantity: "invalid"
      }

      assert %Ecto.Changeset{valid?: false} =
               changeset = Consumables.changeset(consumables_params)

      assert %{
               consumable: ["is invalid"],
               value: ["is invalid"],
               quantity: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      consumables_params = %{
        consumable: "cerveja",
        value: 13,
        quantity: 2
      }

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               Consumables.changeset(consumables_params)

      assert consumables_params.consumable == changes.consumable
      assert consumables_params.value == changes.value
      assert consumables_params.quantity == changes.quantity
    end
  end
end
