defmodule GoBillManager.Bill.Models.BillTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Bill.Models.Bill

  describe "changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Bill.changeset(%{})

      assert %{
               amount: ["can't be blank"],
               consumables: ["can't be blank"],
               status: ["can't be blank"],
               board_id: ["can't be blank"],
               employee_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      bill_params = %{
        amount: "invalid",
        consumables: "invalid",
        status: "invalid",
        board_id: "invalid",
        employee_id: "invalid"
      }

      assert %Ecto.Changeset{valid?: false} = changeset = Bill.changeset(bill_params)

      assert %{
               amount: ["is invalid"],
               consumables: ["is invalid"],
               status: ["is invalid"],
               board_id: ["is invalid"],
               employee_id: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      bill_params = %{
        amount: 10,
        consumables: [
          %{consumable: "cerveja", value: 13, quantity: 2},
          %{consumable: "suco de laranja", value: 9, quantity: 1},
          %{consumable: "prato feito", value: 26, quantity: 2}
        ],
        status: "open",
        board_id: Ecto.UUID.generate(),
        employee_id: Ecto.UUID.generate()
      }

      assert %Ecto.Changeset{changes: changes, valid?: true} = Bill.changeset(bill_params)

      assert bill_params.amount == changes.amount
      assert bill_params.status == Atom.to_string(changes.status)
      assert bill_params.board_id == changes.board_id
      assert bill_params.employee_id == changes.employee_id
    end
  end
end
