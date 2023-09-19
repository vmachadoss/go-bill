defmodule GoBillManagerWeb.EmployeeController do
  @moduledoc """
    Exposes an API interface to create, show and list employees data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.EmployeeCreate

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, employee} <- EmployeeCreate.run(params) do
      render(conn, "create.json", %{employee: employee})
    else
      # TODO - improve nos retornos de erro: required_params
      {:error, %Ecto.Changeset{}} ->
        parse_response_to_json(conn, 400, %{type: "error:invalid_params"})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_response_to_json(conn, status, value) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end
end
