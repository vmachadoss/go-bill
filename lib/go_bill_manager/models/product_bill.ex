defmodule GoBillManager.Models.ProductBill do
  @moduledoc """
  This schema represent the products in bill models
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Models.Bill
  alias GoBillManager.Models.Product

  @type t() :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          bill_id: Ecto.UUID.t() | nil,
          product_id: Ecto.UUID.t() | nil
        }

  @fields ~w(bill_id product_id)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "products_bills" do
    belongs_to(:bill, Bill, foreign_key: :bill_id, type: Ecto.UUID)
    belongs_to(:product, Product, foreign_key: :product_id, type: Ecto.UUID)

    timestamps()
  end

  @spec create_changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def create_changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:bill_id, name: :bills_id_fk)
    |> foreign_key_constraint(:product_id, name: :products_id_fk)
  end
end
