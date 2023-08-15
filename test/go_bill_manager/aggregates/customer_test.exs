defmodule GoBillManager.Aggregates.CustomerTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Aggregates.Customer, as: CustomerAggregate
  alias GoBillManager.Models.Customer
  alias GoBillManager.Models.CustomerTable
  alias GoBillManager.Models.Bill

  describe "create/1" do
    test "should return error when params are required" do
      assert {:error, changeset} = CustomerAggregate.create(%{})

      assert %{
               name: ["can't be blank"],
               bill_id: ["can't be blank"],
               customer_table_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return error when params are invalid" do
      customer_params = string_params_for(:customer, name: -1, bill_id: -1, customer_table_id: -1)
      assert {:error, changeset} = CustomerAggregate.create(customer_params)

      assert %{
               name: ["is invalid"],
               bill_id: ["is invalid"],
               customer_table_id: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return error changeset for constraint error employee_id" do
      customer_params = string_params_for(:customer)

      assert {:error, changeset} = customer_params |> CustomerAggregate.create()

      assert errors_on(changeset) == %{employee_id: ["does not exist"]}
    end
  end

  describe "create_table/1" do
  end
end
