defmodule GoBillManager.Aggregate.EmployeeAggregate do
  @moduledoc """
  This aggregate module take care of Employee insertions, update and delete operations
  """

  alias GoBillManager.Models.Employee
  alias GoBillManager.Repo

  @spec create_employee(map()) :: Employee.t()
  def create_employee(employee_params) do
    employee_params
    |> Employee.changeset()
    |> Repo.insert()
  end
end
