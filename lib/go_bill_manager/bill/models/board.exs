defmodule GoBillManager.Bill.Models.Board do
  @moduledoc """
    Model for represent the tables of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Bill.Models.Bill

  @type t() :: %__MODULE__{}
  
  @primary_key (:id, Ecto.UUID, autogenerate: true)
  schema "board" do
    field :number_of_customers, :integer
    field :status, Ecto.Enum, valus: [:occupated, :available, :cleaning]

    has_one(:bill, Bill, foreign_key: :bill_id)
    timestamps(updated_at: false)
  end
end
