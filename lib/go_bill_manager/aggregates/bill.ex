defmodule GoBillManager.Aggregates.Bill do
  @moduledoc """
  This Aggregate module handle with bills interactions
  """

  alias GoBillManager.Models.Bill
  alias GoBillManager.Repo

  @spec create(params :: map()) :: {:ok, Bill.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Bill.create_changeset()
    |> Repo.insert()
  end
end
