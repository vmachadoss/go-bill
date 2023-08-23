defmodule GoBillManager.Aggregates.CustomerTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Aggregates.Customer, as: CustomerAggregate
  alias GoBillManager.Models.Customer
  alias GoBillManager.Models.CustomerTable

  @test_foreign_key_error %{
    "bill_id" => "bills_id_fk",
    "customer_table_id" => "customers_table_id_fk"
  }

  # TODO - Fazer um setup
  describe "create/1" do
    test "should return ok with valid params" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      %{"name" => name} =
        customer_params =
        string_params_for(:customer, bill_id: bill_id, customer_table_id: customer_table_id)

      assert {:ok,
              %Customer{name: ^name, customer_table_id: ^customer_table_id, bill_id: ^bill_id}} =
               CustomerAggregate.create(customer_params)

      assert Repo.aggregate(Customer, :count, :id) == 1
    end

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

    Enum.each(@test_foreign_key_error, fn {key, _constraint_name} = map ->
      test "should return constraint error #{key} foreign key relation" do
        {key, constraint_name} = unquote(map)

        %{id: employee_id} = insert(:employee)
        %{id: bill_id} = insert(:bill, employee_id: employee_id)
        %{id: customer_table_id} = insert(:customer_table)

        customer_params =
          string_params_for(:customer, bill_id: bill_id, customer_table_id: customer_table_id)

        customer_params = Map.put(customer_params, key, Ecto.UUID.generate())

        error_message = prepare_constraint_error(key, constraint_name)

        assert {:error,
                %Ecto.Changeset{
                  valid?: false,
                  errors: ^error_message
                }} = CustomerAggregate.create(customer_params)
      end
    end)
  end

  describe "create_table/1" do
    test "should return ok with valid params" do
      customer_table_params = string_params_for(:customer_table)

      assert {:ok, %CustomerTable{}} = CustomerAggregate.create_table(customer_table_params)

      assert Repo.aggregate(CustomerTable, :count, :id) == 1
    end

    test "should return error when params are required" do
      assert {:error, changeset} = CustomerAggregate.create_table(%{})

      assert %{state: ["can't be blank"]} == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      customer_table_params = string_params_for(:customer_table, label: -1, state: -1)

      assert {:error, changeset} = CustomerAggregate.create_table(customer_table_params)

      assert %{
               label: ["is invalid"],
               state: ["is invalid"]
             } == errors_on(changeset)
    end
  end

  defp prepare_constraint_error(key, constraint_name),
    do: [
      {String.to_existing_atom(key),
       {"does not exist", [constraint: :foreign, constraint_name: constraint_name]}}
    ]
end
