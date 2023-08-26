defmodule GoBillManager.Models.CustomerTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.Customer

  @test_foreign_key_error %{
    "bill_id" => "bills_id_fk",
    "customer_table_id" => "customers_table_id_fk"
  }

  describe "create_changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Customer.create_changeset(%{})

      assert %{
               name: ["can't be blank"],
               bill_id: ["can't be blank"],
               customer_table_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      customer_params = params_for(:customer, name: -1)

      assert %Ecto.Changeset{valid?: false} =
               changeset = Customer.create_changeset(customer_params)

      assert %{name: ["is invalid"]} == errors_on(changeset)
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
                }} = customer_params |> Customer.create_changeset() |> Repo.insert()
      end
    end)

    test "should return valid changeset when params are valid" do
      customer_params = params_for(:customer)

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               Customer.create_changeset(customer_params)

      assert customer_params.name == changes.name
    end
  end

  defp prepare_constraint_error(key, constraint_name),
    do: [
      {String.to_existing_atom(key),
       {"does not exist", [constraint: :foreign, constraint_name: constraint_name]}}
    ]
end
