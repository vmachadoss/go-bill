defmodule GoBillManager.Repositories.CustomerTableRepository do
  @moduledoc """
  Repository responsible to get values about CustomerTable
  """

  alias GoBillManager.Models.CustomerTable
  alias GoBillManager.Repo

  @spec find(customer_table_id :: Ecto.UUID.t()) ::
          {:ok, CustomerTable.t()} | {:error, :customer_table_not_found}
  def find(customer_table_id) do
    CustomerTable
    |> Repo.get(customer_table_id, telemetry_options: [name: :customer_table_repository_find])
    |> case do
      nil ->
        {:error, :customer_table_not_found}

      customer_table ->
        {:ok, customer_table}
    end
  end

  @spec find!(customer_table_id :: Ecto.UUID.t()) :: CustomerTable.t() | no_return()
  def find!(customer_table_id) do
    customer_table_id
    |> find()
    |> case do
      {:error, :customer_table_not_found} ->
        raise Ecto.NoResultsError, queryable: CustomerTable

      {:ok, customer_table} ->
       customer_table
    end
  end
end
