defmodule GoBillManagerWeb.EmployeeView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{employee: employee}) do
    employee
    |> Map.put(:employee_id, employee.id)
    |> Map.take([:employee_id, :name, :role])
  end
end
