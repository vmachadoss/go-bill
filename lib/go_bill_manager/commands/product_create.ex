defmodule GoBillManager.Commands.ProductCreate do
  @moduledoc """
  Handle with creation and lifecycle of product
  """
  alias Ecto.Multi
  alias GoBillManager.Aggregates.Product, as: ProductAggregate
  alias GoBillManager.Models.Product
  alias GoBillManager.Repo

  require Logger

  @spec run(params :: map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def run(params) do
    Multi.new()
    |> Multi.run(:product_create, fn _, _ -> ProductAggregate.create(params) end)
    |> Repo.transaction(telemetry_options: [name: :product_run_create])
    |> case do
      {:ok, %{product_create: product}} ->
        {:ok, product}

      {:error, step, reason, _} ->
        Logger.error("Creation failed on step: #{step}, for reason: #{inspect(reason)}")

        {:error, reason}
    end
  end
end
