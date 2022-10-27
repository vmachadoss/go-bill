defmodule GoBillManager.Bill.Aggregate.BillAggregateTest do
  @moduledoc false
  use GoBillManager.DataCase

  alias GoBillManager.Bill.Aggregate.BillAggregate
  alias GoBillManager.Bill.Models.Bill

  describe "create_bill/1" do
    test "return error, changeset when params are invalid" do
      bill_params = %{
        "amount" => "invalid",
        "consumables" => "invalid",
        "status" => "invalid",
        "employee_id" => "invalid",
        "board_id" => "invalid"
      }

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               BillAggregate.create_bill(bill_params)

      assert %{
               amount: ["is invalid"],
               consumables: ["is invalid"],
               status: ["is invalid"],
               board_id: ["is invalid"],
               employee_id: ["is invalid"]
             } == errors_on(changeset)

      assert Repo.aggregate(Bill, :count, :id) == 0
    end

    test "should return a valid ok and changeset when the params are valid" do
      %{id: employee_id} = insert(:create_employee)
      %{id: board_id} = insert(:create_board)
      bill_params = string_params_for(:create_bill, employee_id: employee_id, board_id: board_id)

      assert {:ok, %Bill{}} = BillAggregate.create_bill(bill_params)

      assert Repo.aggregate(Bill, :count, :id) == 1
    end
  end
end
