defmodule GoBillManager.Commands.BillCreate do
  @moduledoc """
    Handle with creation and lifecycle of bill
  """

  alias Ecto.Multi
  alias GoBillManager.Aggregates.Bill, as: BillAggregate
  alias GoBillManager.Models.Bill
  alias GoBillManager.Repo
  alias GoBillManager.Repositories.EmployeeRepository

  require Logger

  @spec run(params :: map()) :: {:ok, Bill.t()} | {:error, Ecto.Changeset.t()}
  def run(%{"employee_id" => employee_id} = params) do
    Multi.new()
    |> Multi.run(:verify_if_employee_exists, &verify_if_employee_exists(&1, &2, employee_id))
    |> Multi.run(:bill_create, fn _, _ -> BillAggregate.create(params) end)
    |> Repo.transaction(telemetry_options: [name: :bill_run_create])
    |> case do
      {:ok, %{bill_create: bill}} ->
        {:ok, bill}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end

  defp verify_if_employee_exists(_, _, employee_id) do
    case EmployeeRepository.find(employee_id) do
      {:ok, _} ->
        {:ok, :employee_exists}

      {:error, :employee_not_found} ->
        {:error, :employee_not_found}
    end
  end
end
