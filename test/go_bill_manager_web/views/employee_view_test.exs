defmodule GoBillManagerWeb.EmployeeViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Repositories.EmployeeRepository
  alias GoBillManagerWeb.EmployeeView

  describe "render/2 create.json" do
    test "with success response" do
      employee = insert(:employee)

      rendered_response = EmployeeView.render("create.json", %{employee: employee})

      assert employee.id == rendered_response.employee_id
      assert employee.name == rendered_response.name
      assert employee.role == rendered_response.role
    end
  end

  describe "render/2 index.json" do
    test "with success response" do
      employee = insert(:employee)

      assert employees = EmployeeRepository.list_employees()

      rendered_response = EmployeeView.render("index.json", %{employees: employees})

      assert length(rendered_response) == 1

      assert resp_employee = Enum.at(rendered_response, 0)
      assert employee.id == resp_employee.id
      assert employee.name == resp_employee.name
      assert employee.role == resp_employee.role
    end

    test "without employees" do
      assert employees = EmployeeRepository.list_employees()

      rendered_response = EmployeeView.render("index.json", %{employees: employees})

      assert [] == rendered_response
    end
  end

  describe "render/2 simplified_employee.json" do
    test "with success response" do
      employee = insert(:employee)

      rendered_response = EmployeeView.render("simplified_employee.json", %{employee: employee})

      assert employee.id == rendered_response.id
      assert employee.name == rendered_response.name
      assert employee.role == rendered_response.role
    end
  end
end
