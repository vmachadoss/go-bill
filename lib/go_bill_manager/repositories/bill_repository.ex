defmodule GoBillManager.Repositories.BillRepository do
  @moduledoc """
  Repository responsible to get values about Bills
  """
  import Ecto.Query

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
    Bill
    |> from(as: :bill)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all(telemetry_options: [name: :bill_repository_list_bill])
  end
end
