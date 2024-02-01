defmodule GoBillManager.Repositories.CustomerRepository do
  @moduledoc """
  Repository responsible to get values about Customer
  """
  import Ecto.Query

  alias GoBillManager.Models.Customer
  alias GoBillManager.Repo

  @spec find(customer_id :: Ecto.UUID.t()) :: {:ok, Customer.t()} | {:error, :customer_not_found}
  def find(customer_id) do
    Customer
    |> Repo.get(customer_id, telemetry_options: [name: :customer_repository_find])
    |> case do
      nil ->
        {:error, :customer_not_found}

      customer ->
        {:ok, customer}
    end
  end

  @spec find!(customer_id :: Ecto.UUID.t()) :: Customer.t() | no_return()
  def find!(customer_id) do
    customer_id
    |> find()
    |> case do
      {:error, :customer_not_found} ->
        raise Ecto.NoResultsError, queryable: Customer

      {:ok, customer} ->
        customer
    end
  end

  @spec list_customers :: list() | list(Customer.t())
  def list_customers do
    Customer
    |> from(as: :customer)
    |> order_by([c], desc: c.inserted_at)
    |> Repo.all(telemetry_options: [name: :customer_repository_list_customers])
  end
end
