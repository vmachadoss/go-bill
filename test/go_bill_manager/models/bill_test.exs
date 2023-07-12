defmodule GoBillManager.Models.BillTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Models.Bill

  describe "changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Bill.changeset(%{})

      assert %{
               total_price: ["can't be blank"],
               state: ["can't be blank"],
               employee_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      bill_params = %{
        total_price: "invalid",
        state: -1,
        employee_id: -1
      }

      assert %Ecto.Changeset{valid?: false} = changeset = Bill.changeset(bill_params)

      assert %{
               total_price: ["is invalid"],
               state: ["is invalid"],
               employee_id: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      bill_params = string_params_for(:bill)
      assert %Ecto.Changeset{changes: changes, valid?: true} = Bill.changeset(bill_params)

      assert bill_params["total_price"] == changes.total_price
      assert bill_params["state"] == Atom.to_string(changes.state)
      assert bill_params["employee_id"] == changes.employee_id
    end
  end
end
