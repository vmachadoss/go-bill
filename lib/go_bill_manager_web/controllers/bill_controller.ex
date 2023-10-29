defmodule GoBillManagerWeb.BillController do
  @moduledoc """
    Exposes an API interface to create, show and list bills data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.BillCreate

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, bill} <- BillCreate.run(params) do
      render(conn, "bill_create.json", %{bill: bill})
    else
      {:error, %Ecto.Changeset{}} ->
        parse_response_to_json(conn, 400, %{type: "error:invalid_params"})

      {:error, :employee_not_found} ->
        parse_response_to_json(conn, 404, %{type: "error:employee_not_found_or_exists"})

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
