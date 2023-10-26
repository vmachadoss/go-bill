defmodule GoBillManager.Commands.EmployeeCreate do
  @moduledoc """
    Handle with creation and lifecycle of employee creation
  """

  alias Ecto.Multi
  alias GoBillManager.Aggregates.Employee, as: EmployeeAggregate
  alias GoBillManager.Models.Employee
  alias GoBillManager.Repo

  require Logger

  @spec run(params :: map()) :: {:ok, Employee.t()} | {:error, Ecto.Changeset.t()}
  def run(params) do
    Multi.new()
    |> Multi.run(:employee_create, fn _, _ -> EmployeeAggregate.create(params) end)
    |> Repo.transaction(telemetry_options: [name: :employee_run_create])
    |> case do
      {:ok, %{employee_create: employee}} ->
        {:ok, employee}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end
end
