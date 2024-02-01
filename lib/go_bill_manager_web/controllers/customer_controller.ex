defmodule GoBillManagerWeb.CustomerController do
  @moduledoc """
    Exposes an API interface to create, show and list customer data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.CustomerCreate
  alias GoBillManager.Repositories.CustomerRepository

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, customer} <- CustomerCreate.run(params) do
      render(conn, "create.json", %{customer: customer})
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
        customers: CustomerRepository.list_customers()
      })

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, customer_id} <- EctoUtils.validate_uuid(id),
         {:ok, customer} <- CustomerRepository.find(customer_id) do
      render(conn, "simplified_customer.json", %{customer: customer})
    else
      {:error, :invalid_uuid} ->
        ErrorResponses.bad_request(conn, "invalid_customer_id")

      {:error, :customer_not_found} ->
        ErrorResponses.not_found(conn, "customer_not_found")
    end
  end
end
