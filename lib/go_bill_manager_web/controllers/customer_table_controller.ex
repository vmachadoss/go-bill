defmodule GoBillManagerWeb.CustomerTableController do
  @moduledoc """
    Exposes an API interface to create, show and list customer table data
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
        ErrorResponses.bad_request(conn, "invalid_params")

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
    with {:ok, customer_table_id} <- EctoUtils.validate_uuid(id),
         {:ok, customer_table} <- CustomerTableRepository.find(customer_table_id) do
      render(conn, "simplified_customer_table.json", %{customer_table: customer_table})
    else
      {:error, :invalid_uuid} ->
        ErrorResponses.bad_request(conn, "invalid_customer_table_id")

      {:error, :customer_table_not_found} ->
        ErrorResponses.not_found(conn, "customer_table_not_found")
    end
  end
end
