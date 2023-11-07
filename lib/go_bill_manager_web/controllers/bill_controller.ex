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
        parse_response_to_json(conn, 400, %{type: "error:invalid_params"})

      {:error, :employee_not_found} ->
        parse_response_to_json(conn, 404, %{type: "error:employee_not_found_or_exists"})

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec index(Plug.Con.t(), map()) :: Plug.Conn.t()
  def index(conn, _params), do: render(conn, "index.json", %{bills: BillRepository.list_bills()})

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, bill_id} <- validate_uuid(id),
         {:ok, bill} <- BillRepository.find(bill_id) do
      render(conn, "simplified_bill.json", %{bill: bill})
    else
      {:error, :invalid_uuid} ->
        parse_response_to_json(conn, 400, %{type: "error:invalid_bill_id"})

      {:error, :bill_not_found} ->
        parse_response_to_json(conn, 404, %{type: "error:bill_not_found"})
    end
  end

  defp parse_response_to_json(conn, status, value) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  defp validate_uuid(bill_id) do
    case Ecto.UUID.cast(bill_id) do
      :error -> {:error, :invalid_uuid}
      _ -> {:ok, bill_id}
    end
  end
end
