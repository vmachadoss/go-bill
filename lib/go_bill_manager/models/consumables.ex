defmodule GoBillManager.Models.Consumables do
  @moduledoc """
  This schema represent the consumables in bill models
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @fields ~w(consumable value quantity)a
  embedded_schema do
    field :consumable, :string
    field :value, :integer
    field :quantity, :integer
  end

  @spec changeset(map()) :: Ecto.Changeset.t()
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
