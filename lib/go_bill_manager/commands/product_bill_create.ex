defmodule GoBillManager.Commands.ProductBillCreate do
  @moduledoc """
    Command to handle with cration of product on some bill
  """

  alias GoBillManager.Models.Product
  alias GoBillManager.Models.Bill
  alias GoBillManager.Models.ProductBill
  alias GoBillManager.Aggregates.Product, as: ProductAggregate
  alias GoBillManager.Repositories.BillRepository
  alias GoBillManager.Repositories.ProductRepository

  require Logger

  @spec run(payload :: map()) ::
          {:ok, ProductBill.t()}
          | {:error, :bill_isnt_opened | :bill_not_found, :product_not_found, Ecto.Changeset.t()}
  def run(%{"bill_id" => bill_id, "product_id" => product_id} = params) do
    with {:ok, %Bill{state: :open}} <- BillRepository.find(bill_id),
         {:ok, %Product{}} <- ProductRepository.find(product_id),
         {:ok, %ProductBill{} = product_bill} <- ProductAggregate.create_product_bill(params) do
      {:ok, product_bill}
    else
      {:ok, %Bill{state: _}} ->
        Logger.error("Creation of product bill failed because the bill isn't open")
        {:error, :bill_isnt_opened}

      {:error, reason} when reason in ~w(bill_not_found product_not_found)a ->
        Logger.error("Creation of product bill failed by reason:#{reason}")
        {:error, reason}

      {:error, reason} = err ->
        Logger.error("Creation of product bill failed by reason:#{inspect(reason)}")
        err
    end
  end
end
