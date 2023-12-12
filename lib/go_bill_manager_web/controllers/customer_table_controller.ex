defmodule GoBillManagerWeb.CustomerTableController do
  @moduledoc """
    Exposes an API interface to create, show and list customer table1 data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.CustomerTableCreate
  alias GoBillManager.Repositories.CustomerTableRepository

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

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params),
    do:
      render(conn, "index.json", %{
        customer_tables: CustomerTableRepository.list_customer_tables()
      })

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, customer_table_id} <- validate_uuid(id),
         {:ok, customer_table} <- CustomerTableRepository.find(customer_table_id) do
      render(conn, "simplified_customer_table.json", %{customer_table: customer_table})
    else
      {:error, :invalid_uuid} ->
        parse_response_to_json(conn, 400, %{type: "error:invalid_customer_table_id"})

      {:error, :customer_table_not_found} ->
        parse_response_to_json(conn, 404, %{type: "error:customer_table_not_found"})
    end
  end

  defp parse_response_to_json(conn, status, value) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  defp validate_uuid(customer_table_id) do
    case Ecto.UUID.cast(customer_table_id) do
      :error -> {:error, :invalid_uuid}
      _ -> {:ok, customer_table_id}
    end
  end
end
