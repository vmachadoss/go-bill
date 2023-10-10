defmodule GoBillManager.Repositories.EmployeeRepository do
  @moduledoc """
  Repository responsible to get values about Employees
  """

  import Ecto.Query

  alias GoBillManager.Models.Employee
  alias GoBillManager.Repo

  @spec find(employee_id :: Ecto.UUID.t()) :: {:ok, Employee.t()} | {:error, :employee_not_found}
  def find(employee_id) do
    Employee
    |> Repo.get(employee_id, telemetry_options: [name: :employee_repository_find])
    |> case do
      nil ->
        {:error, :employee_not_found}

      employee ->
        {:ok, employee}
    end
  end

  @spec find!(employee_id :: Ecto.UUID.t()) :: Employee.t() | no_return()
  def find!(employee_id) do
    employee_id
    |> find()
    |> case do
      {:error, :employee_not_found} ->
        raise Ecto.NoResultsError, queryable: Employee

      {:ok, employee} ->
        employee
    end
  end

  @spec list_employees :: list() | list(Employee.t())
  def list_employees do
    Employee
    |> from(as: :employee)
    |> order_by([e], desc: e.inserted_at)
    |> Repo.all(telemetry_options: [name: :employee_repository_list_employees])
  end
end
