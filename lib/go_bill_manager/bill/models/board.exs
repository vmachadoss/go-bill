defmodule GoBillManager.Bill.Models.Board do
  @moduledoc """
    Model for represent the tables of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias GoBillManager.Bill.Models.Bill

  @type t() :: %__MODULE__{}
  
  @status ~w(occupated available cleaning)a

  @primary_key (:id, Ecto.UUID, autogenerate: true)
  schema "board" do
    field :number_of_customers, :integer
    field :status, Ecto.Enum, valus: @status

    has_one(:bill, Bill, foreign_key: :bill_id)
    timestamps(updated_at: false)
  end

  @spec changeset(struct :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:number_of_customers, :status])
    |> validate_required([:number_of_customers, :status])
    |> validate_inclusion(:status, @status)
  end
end
