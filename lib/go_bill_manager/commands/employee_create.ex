defmodule GoBillManager.Commands.EmployeeCreate do
  @moduledoc """
    Handle with creation and lifecycle of employee creation
  """

  alias GoBillManager.Aggregates.Employee, as: EmployeeAggregate
  alias GoBillManager.Models.Employee
  alias GoBillManager.Repo
  alias Ecto.Multi

  require Logger

  @spec run(params :: map()) :: {:ok, Employee.t()} | {:error, Ecto.Changeset.t()}
  def run(params) do
    Multi.new()
    |> Multi.run(:employee_create, fn _, _ -> EmployeeAggregate.create(params) end)
    |> Repo.transaction(telemetry_options: [name: :employee_run_create])
    |> case do
      {:ok, changes} ->
        {:ok, changes}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end
end
