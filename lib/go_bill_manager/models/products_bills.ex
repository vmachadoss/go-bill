defmodule GoBillManager.Models.ProductsBills do
  @moduledoc """
  This schema represent the products in bill models
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @fields ~w(name retail_price description)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "products" do
    timestamps()
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
