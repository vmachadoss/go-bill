defmodule GoBillManagerWeb.BillController do
  @moduledoc """
    Exposes an API interface to create, show and list bills data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.BillCreate
  alias GoBillManager.Repositories.BillRepository

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, bill} <- BillCreate.run(params) do
      render(conn, "create.json", %{bill: bill})
    else
      {:error, %Ecto.Changeset{}} ->
        ErrorResponses.bad_request(conn, "invalid_params")

      {:error, :employee_not_found} ->
        ErrorResponses.not_found(conn, "employee_not_found")

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params), do: render(conn, "index.json", %{bills: BillRepository.list_bills()})

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, bill_id} <- EctoUtils.validate_uuid(id),
         {:ok, bill} <- BillRepository.find(bill_id) do
      render(conn, "simplified_bill.json", %{bill: bill})
    else
      {:error, :invalid_uuid} ->
        ErrorResponses.bad_request(conn, "invalid_bill_id")

      {:error, :bill_not_found} ->
        ErrorResponses.not_found(conn, "bill_not_found")
    end
  end
end
