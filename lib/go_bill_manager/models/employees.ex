defmodule GoBillManager.Models.Employees do
  @moduledoc """
    Module for represent the employee of establishment
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @roles ~w(attendant manager)a

  @fields ~w(name role)a
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "employees" do
    field :name, :string
    field :role, Ecto.Enum, values: @roles

    timestamps(updated_at: false)
  end

  @spec changeset(module :: t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
