defmodule GoBillManager.Utils.EctoUtils do
  @moduledoc """
    Utils functions to handle with ecto issues
  """

  @spec validate_uuid(any) :: {:ok, Ecto.UUID.t()} | {:error, :invalid_uuid}
  def validate_uuid(uuid) do
    case Ecto.UUID.cast(uuid) do
      :error -> {:error, :invalid_uuid}
      _ -> {:ok, uuid}
    end
  end
end
