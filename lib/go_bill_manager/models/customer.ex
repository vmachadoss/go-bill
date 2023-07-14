defmodule GoBillManager.Models.Customer do
  @moduledoc """
    Model for represent the client of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Models.Bill
  alias GoBillManager.Models.CustomerTable

  @type t() :: %__MODULE__{}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "customers" do
    field :name, :string

    belongs_to(:bill, Bill, foreign_key: :bill_id, type: Ecto.UUID)
    belongs_to(:customer_table, CustomerTable, foreign_key: :customer_table_id, type: Ecto.UUID)

    timestamps(updated_at: false)
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, [:name])
    |> validate_required([:name])
    |> foreign_key_constraint(:customer_table_id, name: :customers_table_id_fk)
    |> foreign_key_constraint(:bill_id, name: :bill_id_fk)
    |> unique_constraint([:bill_id], name: :customers_bill_unique_index)
  end
end
