defmodule GoBillManager.Aggregates.EmployeeTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Aggregates.Employee, as: EmployeeAggregate
  alias GoBillManager.Models.Employee

  describe "create/1" do
    test "should return ok with valid params" do
      employee_params = string_params_for(:employee)

      assert {:ok, %Employee{} = employee_response} = EmployeeAggregate.create(employee_params)

      assert employee_params["name"] == employee_response.name
      assert employee_params["role"] == Atom.to_string(employee_response.role)
    end

    test "should return error when params are required" do
      assert {:error, changeset} = EmployeeAggregate.create(%{})

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               role: ["can't be blank"]
             }
    end

    test "should return error when params are invalid" do
      employee_params = string_params_for(:employee, name: -1, role: -2)

      assert {:error, changeset} = EmployeeAggregate.create(employee_params)

      assert errors_on(changeset) == %{
               name: ["is invalid"],
               role: ["is invalid"]
             }
    end
  end
end
