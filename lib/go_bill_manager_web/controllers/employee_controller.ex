defmodule GoBillManagerWeb.EmployeeController do
  @moduledoc """
    Exposes an API interface to create, show and list employees data
  """
  use GoBillManagerWeb, :controller

  alias GoBillManager.Aggregates.Employee, as: EmployeeAggregate

  # transaction e command ?
  # isolar a transação que vai inserir no banco.
  
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, employee} <- EmployeeAggregate.create(params) do
      render(conn, "create.json", %{employee: employee})
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        handle_invalid_params()
    end
  end
end
