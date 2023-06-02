defmodule GoBillManager.Aggregate.BillAggregate do
  @moduledoc """
  This aggregate module take care of Bill insertions, update and delete operations
  """

  alias GoBillManager.Models.Bill
  alias GoBillManager.Repo

  @spec create_bill(map()) :: Bill.t()
  def create_bill(bill_params) do
    bill_params
    |> Bill.changeset()
    |> Repo.insert()
  end
end
