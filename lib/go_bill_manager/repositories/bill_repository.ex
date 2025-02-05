defmodule GoBillManager.Repositories.BillRepository do
  @moduledoc """
  Repository responsible to get values about Bills
  """
  import Ecto.Query

  alias GoBillManager.Models.Product
  alias GoBillManager.Models.ProductBill
  alias GoBillManager.Models.Bill
  alias GoBillManager.Repo

  @spec find(bill_id :: Ecto.UUID.t()) :: {:ok, Bill.t()} | {:error, :bill_not_found}
  def find(bill_id) do
    Bill
    |> Repo.get(bill_id, telemetry_options: [name: :bill_repository_find])
    |> case do
      nil ->
        {:error, :bill_not_found}

      bill ->
        {:ok, bill}
    end
  end

  @spec find!(bill_id :: Ecto.UUID.t()) :: Bill.t() | no_return()
  def find!(bill_id) do
    bill_id
    |> find()
    |> case do
      {:error, :bill_not_found} ->
        raise Ecto.NoResultsError, queryable: Bill

      {:ok, bill} ->
        bill
    end
  end

  @spec list_bills :: list() | list(Bill.t())
  def list_bills do
    products_bill = products_bill()

    Bill
    |> from(as: :bill)
    |> join(:inner_lateral, [b], b in ^products_bill, as: :products_bill)
    # |> join(:left, [b], pb in ProductBill, on: b.id == pb.bill_id, as: :product_bill)
    # |> join(:left, [_, pb], p in Product, on: pb.product_id == p.id, as: :products)
    |> distinct([b], b.id)
    |> select([b, pb], %{bill: b, products: pb})
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all(telemetry_options: [name: :bill_repository_list_bill])
  end

  def products_bill do
    ProductBill
    |> from(as: :product_bill)
    |> join(:left, [pb], p in Product, on: pb.product_id == p.id, as: :products)
    |> where([pb, _], parent_as(:bill).id == pb.bill_id)
    |> order_by(desc: :inserted_at)
    |> subquery()
  end
end
