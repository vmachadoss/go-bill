defmodule GoBillManager.Models.BillTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Models.Bill
  alias GoBillManager.Repo

  describe "create_changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Bill.create_changeset(%{})

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

      assert %Ecto.Changeset{valid?: false} = changeset = Bill.create_changeset(bill_params)

      assert %{
               total_price: ["is invalid"],
               state: ["is invalid"],
               employee_id: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return error changeset for constraint error employee_id" do
      bill_params = params_for(:bill, employee_id: Ecto.UUID.generate())
      assert {:error, changeset} = bill_params |> Bill.create_changeset() |> Repo.insert()

      assert errors_on(changeset) == %{employee_id: ["does not exist"]}
    end

    test "should return valid changeset when params are valid" do
      %{id: employee_id} = insert(:employee)
      bill_params = string_params_for(:bill, employee_id: employee_id)
      assert %Ecto.Changeset{changes: changes, valid?: true} = Bill.create_changeset(bill_params)

      assert bill_params["total_price"] == changes.total_price
      assert bill_params["state"] == Atom.to_string(changes.state)
      assert bill_params["employee_id"] == changes.employee_id
    end

    test "should return foreign key error employee id" do
      bill_params = string_params_for(:bill, employee_id: Ecto.UUID.generate())

      assert {:error, changeset} = Bill.create_changeset(bill_params) |> Repo.insert()

      assert %{employee_id: ["does not exist"]} = errors_on(changeset)
    end
  end
end
