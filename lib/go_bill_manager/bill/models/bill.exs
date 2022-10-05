defmodule GoBillManager.Bill.Models.Bill do
  @moduledoc """
    Model for bill of the tables (boards)
  """

  use Ecto.Schema

  import Ecto.Changeset
  
  alias GoBillManager.Bill.Models.Board
  alias GoBillManager.Bill.Models.Employee

  @type t() :: %__MODULE__{}

  @primary_key (:id, Ecto.UUID, autogenerate: true)
  schema "bill" do
    field :amount, :float
    field :consumables, :map
    field :status, Ecto.Enum, values: [:open, :close]
    
    belongs_to(:board, Board, type: Ecto.UUID)
    belongs_to(:employee, Employee, type: Ecto.UUID)

    timestamps()
  end
end
