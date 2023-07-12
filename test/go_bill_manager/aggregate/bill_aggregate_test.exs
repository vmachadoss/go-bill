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

    test "should return error, changeset invalid when params are empties" do
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} = BillAggregate.create_bill(%{})

      assert %{
               amount: ["can't be blank"],
               consumables: ["can't be blank"],
               status: ["can't be blank"],
               board_id: ["can't be blank"],
               employee_id: ["can't be blank"]
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

    test "should return error, changeset when params are valid but employee_id and board_id dosen't send" do
      bill_params = string_params_for(:create_bill)

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                errors: [
                  employee_id:
                    {"does not exist", [constraint: :foreign, constraint_name: "employee_id_fk"]}
                ],
                valid?: false
              }} = BillAggregate.create_bill(bill_params)

      assert Repo.aggregate(Bill, :count, :id) == 0
    end

    test "should return erro, invalid changeset when params are valid but dosen't sent board_id" do
      %{id: employee_id} = insert(:create_employee)
      bill_params = string_params_for(:create_bill, employee_id: employee_id)

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                errors: [
                  board_id:
                    {"does not exist", [constraint: :foreign, constraint_name: "board_id_fk"]}
                ],
                valid?: false
              }} = BillAggregate.create_bill(bill_params)

      assert Repo.aggregate(Bill, :count, :id) == 0
    end
  end
end
