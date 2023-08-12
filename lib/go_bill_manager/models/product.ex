defmodule GoBillManager.Models.Product do
  @moduledoc """
  This schema represent the products in bill models
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @fields ~w(name retail_price description)a

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "products" do
    field :name, :string
    field :retail_price, :integer
    field :description, :string

    timestamps()
  end

  @spec create_changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def create_changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
