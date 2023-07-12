defmodule GoBillManager.Bill.Aggregate.EmployeeAggregateTest do
  @moduledoc false
  use GoBillManager.DataCase

  alias GoBillManager.Bill.Aggregate.EmployeeAggregate
  alias GoBillManager.Bill.Models.Employee

  describe "create_employee/1" do
    test "return error, changeset when params are invalid" do
      employee_params = string_params_for(:create_employee, name: -1, role: -1)

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               EmployeeAggregate.create_employee(employee_params)

      assert %{name: ["is invalid"], role: ["is invalid"]} == errors_on(changeset)

      assert Repo.aggregate(Employee, :count, :id) == 0
    end

    test "should return error, changeset invalid when params are empties" do
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               EmployeeAggregate.create_employee(%{})

      assert %{name: ["can't be blank"], role: ["can't be blank"]} == errors_on(changeset)

      assert Repo.aggregate(Employee, :count, :id) == 0
    end

    test "should return a valid ok and changeset when the params are valid" do
      employee_params = string_params_for(:create_employee)

      assert {:ok, %Employee{}} = EmployeeAggregate.create_employee(employee_params)

      assert Repo.aggregate(Employee, :count, :id) == 1
    end
  end
end
