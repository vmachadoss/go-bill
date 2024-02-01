defmodule GoBillManager.Commands.CustomerCreate do
  @moduledoc """
  Handle with creation and lifecycle of customer
  """
  alias Ecto.Multi
  alias GoBillManager.Aggregates.Customer, as: CustomerAggregate
  alias GoBillManager.Models.Customer
  alias GoBillManager.Repo

  require Logger

  @spec run(params :: map()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def run(params) do
    Multi.new()
    |> Multi.run(:customer_create, fn _, _ -> CustomerAggregate.create(params) end)
    |> Repo.transaction(telemetry_options: [name: :customer_run_create])
    |> case do
      {:ok, %{customer_create: customer}} ->
        {:ok, customer}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end
end
