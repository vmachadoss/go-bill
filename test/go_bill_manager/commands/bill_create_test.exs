defmodule GoBillManager.Commands.BillCreateTest do
  use GoBillManager.DataCase

  alias GoBillManager.Commands.BillCreate
  alias GoBillManager.Models.Bill

  describe "run/1" do
    test "should return error when employee not exists" do
      params = %{"employee_id" => Ecto.UUID.generate()}
      {{:error, :employee_not_found}, log} = with_log(fn -> BillCreate.run(params) end)

      assert log =~
               ~s/[error] Creation failed on step: verify_if_employee_exists, for reason: :employee_not_found/
    end

    test "should return error when params are required" do
      %{id: employee_id} = insert(:employee)

      {{:error, invalid_changeset}, log} =
        with_log(fn -> BillCreate.run(%{"employee_id" => employee_id}) end)

      assert errors_on(invalid_changeset) == %{
               total_price: ["can't be blank"],
               state: ["can't be blank"]
             }

      assert log =~ ~s/[error] Creation failed on step: bill_create, for reason: /
    end

    test "should return error when params are invalid" do
      %{id: employee_id} = insert(:employee)

      params = %{"employee_id" => employee_id, "total_price" => "invalid", "state" => -1}

      {{:error, invalid_changeset}, log} = with_log(fn -> BillCreate.run(params) end)

      assert errors_on(invalid_changeset) == %{total_price: ["is invalid"], state: ["is invalid"]}
      assert log =~ ~s/[error] Creation failed on step: bill_create, for reason: /
    end

    test "should return ok and result when params are valid" do
      %{id: employee_id} = insert(:employee)

      %{"total_price" => total_price, "state" => state} =
        bill_params = string_params_for(:bill, employee_id: employee_id)

      assert {:ok, %Bill{} = resp_bill} = BillCreate.run(bill_params)

      assert ^total_price = resp_bill.total_price
      assert ^state = Atom.to_string(resp_bill.state)
    end
  end
end
