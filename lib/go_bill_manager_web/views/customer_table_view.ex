defmodule GoBillManagerWeb.CustomerTableView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{customer_table: customer_table}) do
    customer_table
    |> Map.put(:customer_table_id, customer_table.id)
    |> Map.take([:customer_table_id, :label, :state])
  end
end
