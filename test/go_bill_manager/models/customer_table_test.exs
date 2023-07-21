defmodule GoBillManager.Models.CustomerTableTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.CustomerTable

  describe "changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = CustomerTable.changeset(%{})

      assert %{state: ["can't be blank"]} == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      customer_table_params = params_for(:customer_table, label: "invalid", state: -1)

      assert %Ecto.Changeset{valid?: false} = changeset = CustomerTable.changeset(customer_table_params)

      assert %{
               label: ["is invalid"],
               state: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      customer_table_params = params_for(:customer_table)

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               CustomerTable.changeset(customer_table_params)

      assert customer_table_params.label == changes.label
      assert customer_table_params.state == Atom.to_string(changes.state)
    end
  end
end
