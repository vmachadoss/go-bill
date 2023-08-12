defmodule GoBillManager.Aggregates.Employee do
  @moduledoc """
  This Aggregate module handle with employee interactions
  """

  alias GoBillManager.Models.Employee
  alias GoBillManager.Repo

  @spec create(params :: map()) :: {:ok, Employee.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    params
    |> Employee.create_changeset()
    |> Repo.insert()
  end
end
