defmodule GoBillManager.Commands.CustomerTableCreateTest do
  use GoBillManager.DataCase

	alias GoBillManager.Commands.CustomerTableCreate
  alias GoBillManager.Models.CustomerTable

  describe "run/1" do
    test "should return error when params are required" do
      {{:error, invalid_changeset}, log} = with_log(fn -> CustomerTableCreate.run(%{}) end)

      assert errors_on(invalid_changeset) == %{state: ["can't be blank"]}
      assert log =~ ~s/[error] Creation failed on step: customer_table_create, for reason: /
    end

    test "should return error when params are invalid" do
      {{:error, invalid_changeset}, log} =
        with_log(fn -> CustomerTableCreate.run(%{"label" => -1, "state" => -1}) end)

      assert errors_on(invalid_changeset) == %{label: ["is invalid"], state: ["is invalid"]}
      assert log =~ ~s/[error] Creation failed on step: customer_table_create, for reason: /
    end

    test "should return ok and result when params are valid" do
      %{"label" => customer_table_label, "state" => customer_table_state} =
        customer_table_params =
        :customer_table
        |> string_params_for()
        |> Map.take(["label", "state"])

      assert {:ok, %CustomerTable{} = resp_customer_table} = CustomerTableCreate.run(customer_table_params)

      assert customer_table_label == resp_customer_table.label
      assert customer_table_state == resp_customer_table.state
    end
  end
end
