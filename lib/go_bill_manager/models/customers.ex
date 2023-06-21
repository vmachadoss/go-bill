defmodule GoBillManager.Models.Customers do
  @moduledoc """
    Model for represent the client of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "customers" do
    field :name, :string

    timestamps(updated_at: false)
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
