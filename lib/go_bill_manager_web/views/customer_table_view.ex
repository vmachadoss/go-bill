defmodule GoBillManagerWeb.CustomerTableView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{customer_table: customer_table}) do
    customer_table
    |> Map.put(:customer_table_id, customer_table.id)
    |> Map.take([:customer_table_id, :label, :state])
  end

  def render("index.json", %{customer_tables: customer_tables}) do
    render_many(customer_tables, __MODULE__, "simplified_customer_table.json",
      as: :customer_table
    )
  end

  def render("simplified_customer_table.json", %{customer_table: customer_table}) do
    %{
      id: customer_table.id,
      label: customer_table.label,
      state: customer_table.state
    }
  end
end
