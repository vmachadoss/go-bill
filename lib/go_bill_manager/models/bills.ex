defmodule GoBillManager.Models.Bills do
  @moduledoc """
    Model for bills of the customers tables
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Models.Employees

  @type t() :: %__MODULE__{}

  @status ~w(open close)a
  @castable_fields ~w(amount status board_id employee_id)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "bills" do
    field :total_price, :integer
    field :status, Ecto.Enum, values: @status

    belongs_to(:employee, Employees, foreign_key: :employee_id, type: Ecto.UUID)

    timestamps()
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @castable_fields)
    |> validate_required(@castable_fields)
    |> foreign_key_constraint(:employee_id, name: :employee_id_fk)
  end
end
