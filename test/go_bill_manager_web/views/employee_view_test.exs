defmodule GoBillManagerWeb.EmployeeViewTest do
  use GoBillManager.DataCase, async: true

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
end
