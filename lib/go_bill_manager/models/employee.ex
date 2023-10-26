defmodule GoBillManager.Models.Employee do
  @moduledoc """
    Module for represent the employee of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset
  alias GoBillManager.Models.Bill

  @type valid_roles() :: :attendant | :manager

  @type t() :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t() | nil,
          role: valid_roles() | nil
        }

  @roles ~w(attendant manager)a

  @fields ~w(name role)a
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "employees" do
    field :name, :string
    field :role, Ecto.Enum, values: @roles

    has_many(:bills, Bill, foreign_key: :employee_id)
    timestamps(updated_at: false)
  end

  @spec create_changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def create_changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
