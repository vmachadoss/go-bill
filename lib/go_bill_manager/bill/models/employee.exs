defmodule GoBillManager.Bill.Models.Employee do
  @moduledoc """
    Module for represent the employee of establishment
  """

  use Ecto.Schema
  
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key (:id, Ecto.UUID, autogenerate: true)
  schema "employee" do
    field :name, :string
    field :role, Ecto.Enum, values: [:attendant, :manager]
    
    has_many(:bill, Bill, foreign_key: :bill_id)
    timestamps()
  end
end
