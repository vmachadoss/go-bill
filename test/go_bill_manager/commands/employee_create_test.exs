defmodule GoBillManager.Commands.EmployeeCreateTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.Employee
  alias GoBillManager.Commands.EmployeeCreate

  describe "run/1" do
    test "should return error when params are required" do
      {{:error, invalid_changeset}, log} = with_log(fn -> EmployeeCreate.run(%{}) end)

      assert errors_on(invalid_changeset) == %{name: ["can't be blank"], role: ["can't be blank"]}
      assert log =~ ~s/[error] Creation failed on step: employee_create, for reason: /
    end

    test "should return error when params are invalid" do
      {{:error, invalid_changeset}, log} = with_log(fn -> EmployeeCreate.run(%{"name" => -1, "role" => -1}) end)

      assert errors_on(invalid_changeset) == %{name: ["is invalid"], role: ["is invalid"]}
      assert log =~ ~s/[error] Creation failed on step: employee_create, for reason: /
    end

    test "should return ok and result when params are valid" do
      %{"name" => employee_name, "role" => employee_role} =
        employee_params =
        :employee
        |> string_params_for()
        |> Map.take(["name", "role"])

      assert {:ok, %{employee_create: %Employee{} = resp_employee}} =
               EmployeeCreate.run(employee_params)

      assert employee_name == resp_employee.name
      assert employee_role == Atom.to_string(resp_employee.role)
    end
  end
end
