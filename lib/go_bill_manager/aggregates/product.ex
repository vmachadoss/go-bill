defmodule GoBillManager.Aggregates.Product do
  @moduledoc """
  This Aggregate module handle with employee interactions
  """

  alias GoBillManager.Models.Product
  alias GoBillManager.Models.ProductBill
  alias GoBillManager.Repo

  @spec create(params :: map()) :: {:ok, Product.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Product.create_changeset()
    |> Repo.insert()
  end

  @spec create_product_bill(params :: map()) ::
          {:ok, ProductBill.t()} | {:error, Ecto.Changeset.t()}
  def create_product_bill(params) do
    params
    |> ProductBill.create_changeset()
    |> Repo.insert()
  end
end
