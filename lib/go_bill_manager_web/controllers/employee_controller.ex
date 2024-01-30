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
      {:error, %Ecto.Changeset{}} ->
        ErrorResponses.bad_request(conn, "invalid_params")

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params),
    do: render(conn, "index.json", %{employees: EmployeeRepository.list_employees()})

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, employee_id} <- EctoUtils.validate_uuid(id),
         {:ok, employee} <- EmployeeRepository.find(employee_id) do
      render(conn, "simplified_employee.json", %{employee: employee})
    else
      {:error, :invalid_uuid} ->
        ErrorResponses.bad_request(conn, "invalid_employee_id")

      {:error, :employee_not_found} ->
        ErrorResponses.not_found(conn, "employee_not_found")
    end
  end
end
