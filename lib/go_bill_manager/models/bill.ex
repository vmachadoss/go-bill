defmodule GoBillManager.Models.Bill do
  @moduledoc """
    Model for bills of the customers tables
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Models.Employee
  alias GoBillManager.Models.Customer

  @type t() :: %__MODULE__{}

  @states ~w(open close)a
  @castable_fields ~w(total_price state employee_id)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "bills" do
    field :total_price, :integer
    field :state, Ecto.Enum, values: @states

    belongs_to(:employee, Employee, type: Ecto.UUID)
    has_one(:customer, Customer)
    timestamps()
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @castable_fields)
    |> validate_required(@castable_fields)
    |> foreign_key_constraint(:employee_id, name: :employees_id_fk)
  end
end
