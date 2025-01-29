defmodule GoBillManager.Utils.EctoUtils do
  @moduledoc """
    Utils functions to handle with ecto issues
  """

  @spec validate_uuid(uuid :: String.t()) :: {:ok, Ecto.UUID.t()} | {:error, :invalid_uuid}
  def validate_uuid(uuid) do
    case Ecto.UUID.cast(uuid) do
      :error -> {:error, :invalid_uuid}
      _ -> {:ok, uuid}
    end
  end

  @spec all_valid_uuids?(uuids :: list()) :: boolean()
  def all_valid_uuids?(uuids) do
    uuids
    |> Enum.map(&validate_uuid(&1))
    |> Keyword.keys()
    |> Enum.all?(&(&1 == :ok))
  end
end
