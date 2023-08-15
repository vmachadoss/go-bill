defmodule GoBillManager.Aggregates.BillTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Aggregates.Bill, as: BillAggregate
  alias GoBillManager.Models.Bill

  describe "create/1" do
    test "should return error when params are required" do
      assert {:error, changeset} = BillAggregate.create(%{})

      assert %{
               total_price: ["can't be blank"],
               state: ["can't be blank"],
               employee_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return error when params are invalid" do
      bill_params = string_params_for(:bill, total_price: "invalid", state: -1, employee_id: -1)

      assert {:error, changeset} = BillAggregate.create(bill_params)

      assert %{
               total_price: ["is invalid"],
               state: ["is invalid"],
               employee_id: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return error changeset for constraint error employee_id" do
      bill_params = string_params_for(:bill, employee_id: Ecto.UUID.generate())

      assert {:error, changeset} = bill_params |> BillAggregate.create()

      assert errors_on(changeset) == %{employee_id: ["does not exist"]}
    end

    test "should return valid changeset when params are valid" do
      %{id: employee_id} = insert(:employee)
      bill_params = string_params_for(:bill, employee_id: employee_id)
      assert {:ok, %Bill{}} = BillAggregate.create(bill_params)

      assert Repo.aggregate(Bill, :count, :id) == 1
    end
  end
end
