defmodule GoBillManager.Aggregates.Customer do
  @moduledoc """
  This Aggregate module handle with customer and customer table interactions
  """

  alias GoBillManager.Models.Customer
  alias GoBillManager.Models.CustomerTable
  alias GoBillManager.Repo

  @spec create(params :: map()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Customer.create_changeset()
    |> Repo.insert()
  end

  @spec create_table(params :: map()) :: {:ok, CustomerTable.t()} | {:error, Ecto.Changeset.t()}
  def create_table(params) do
    params
    |> CustomerTable.create_changeset()
    |> Repo.insert()
  end
end
