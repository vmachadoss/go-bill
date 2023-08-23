defmodule GoBillManager.Models.CustomerTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.Customer

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

    test "should return valid changeset when params are valid" do
      customer_params = params_for(:customer)

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               Customer.create_changeset(customer_params)

      assert customer_params.name == changes.name
    end
  end
end
