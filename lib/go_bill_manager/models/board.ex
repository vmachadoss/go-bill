defmodule GoBillManager.Models.Board do
  @moduledoc """
    Model for represent the tables of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Models.Bill

  @type t() :: %__MODULE__{}

  @status ~w(occupated available cleaning)a

  @required_fields ~w(number_of_customers status)a
  @fields ~w(number_of_customers status)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "board" do
    field :number_of_customers, :integer
    field :status, Ecto.Enum, values: @status

    has_one :bill, Bill, foreign_key: :board_id
    timestamps(updated_at: false)
  end

  @spec changeset(struct :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> cast_assoc(:bill, with: &Bill.changeset/1)
    |> validate_required(@required_fields)
  end
end
