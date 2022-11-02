defmodule GoBillManager.Bill.Models.Employee do
  @moduledoc """
    Module for represent the employee of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Bill.Models.Bill

  @type t() :: %__MODULE__{}

  @roles ~w(attendant manager)a

  @fields ~w(name role)a
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "employee" do
    field :name, :string
    field :role, Ecto.Enum, values: @roles

    has_many :bill, Bill, foreign_key: :employee_id
    timestamps()
  end

  @spec changeset(struct :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> cast_assoc(:bill, with: &Bill.changeset/1)
    |> validate_required(@fields)
  end
end
