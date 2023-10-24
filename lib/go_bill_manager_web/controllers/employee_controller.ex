defmodule GoBillManagerWeb.EmployeeController do
  @moduledoc """
    Exposes an API interface to create, show and list employees data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Commands.EmployeeCreate
  alias GoBillManager.Repositories.EmployeeRepository

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

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params),
    do: render(conn, "index.json", %{employees: EmployeeRepository.list_employees()})

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, employee_id} <- validate_uuid(id),
         {:ok, employee} <- EmployeeRepository.find(employee_id) do
      render(conn, "simplified_employee.json", %{employee: employee})
    else
      {:error, :invalid_uuid} ->
        parse_response_to_json(conn, 400, %{type: "error:invalid_employee_id"})

      {:error, :employee_not_found} ->
        parse_response_to_json(conn, 404, %{type: "error:employee_not_found"})
    end
  end

  defp parse_response_to_json(conn, status, value) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  defp validate_uuid(employee_id) do
    case Ecto.UUID.cast(employee_id) do
      :error -> {:error, :invalid_uuid}
      _ -> {:ok, employee_id}
    end
  end
end
