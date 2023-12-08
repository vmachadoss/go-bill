defmodule GoBillManagerWeb.CustomerTableController do
  @moduledoc """
    Exposes an API interface to create, show and list customer table1 data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.CustomerTableCreate

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, customer_table} <- CustomerTableCreate.run(params) do
      render(conn, "create.json", %{customer_table: customer_table})
    else
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
