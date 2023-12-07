defmodule GoBillManager.Commands.CustomerTableCreate do
  @moduledoc """
  Handle with creation and lifecycle of customer table
  """
  alias Ecto.Multi
  alias GoBillManager.Aggregates.Customer, as: CustomerTableAggregate
  alias GoBillManager.Models.CustomerTable
  alias GoBillManager.Repo

  require Logger

  @spec run(params :: map()) :: {:ok, CustomerTable.t()} | {:error, Ecto.Changeset.t()}
  def run(params) do
    Multi.new()
    |> Multi.run(:customer_table_create, fn _, _ -> CustomerTableAggregate.create_table(params) end)
    |> Repo.transaction(telemetry_options: [name: :customer_table_run_create])
    |> case do
      {:ok, %{customer_table_create: customer_table}} ->
        {:ok, customer_table}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end
end
