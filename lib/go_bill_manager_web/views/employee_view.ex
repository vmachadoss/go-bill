defmodule GoBillManagerWeb.EmployeeView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{employee: employee}) do
    employee
    |> Map.put(:employee_id, employee.id)
    |> Map.take([:employee_id, :name, :role])
  end

  def render("index.json", %{employees: employees}) do
    render_many(employees, __MODULE__, "simplified_employee.json", as: :employee)
  end

  def render("simplified_employee.json", %{employee: employee}) do
    %{
      id: employee.id,
      name: employee.name,
      role: employee.role
    }
  end
end
