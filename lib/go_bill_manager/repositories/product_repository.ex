defmodule GoBillManager.Repositories.ProductRepository do
  @moduledoc """
  Repository responsible to get values about product
  """
  import Ecto.Query

  alias GoBillManager.Models.Product
  alias GoBillManager.Repo

  @spec find(product_id :: Ecto.UUID.t()) :: {:ok, Product.t()} | {:error, :product_not_found}
  def find(product_id) do
    Product
    |> Repo.get(product_id, telemetry_options: [name: :product_repository_find])
    |> case do
      nil ->
        {:error, :product_not_found}

      product ->
        {:ok, product}
    end
  end

  @spec find!(product_id :: Ecto.UUID.t()) :: Product.t() | no_return()
  def find!(product_id) do
    product_id
    |> find()
    |> case do
      {:error, :product_not_found} ->
        raise Ecto.NoResultsError, queryable: Product

      {:ok, product} ->
        product
    end
  end

  @spec list_products :: list() | list(Product.t())
  def list_products do
    Product
    |> from(as: :product)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all(telemetry_options: [name: :product_repository_list_products])
  end
end
