defmodule GoBillManagerWeb.CustomerView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{customer: customer}) do
    customer
    |> Map.put(:customer_id, customer.id)
    |> Map.take([:customer_id, :name, :bill_id, :customer_table_id])
  end

  def render("index.json", %{customers: customers}) do
    render_many(customers, __MODULE__, "simplified_customer.json", as: :customer)
  end

  def render("simplified_customer.json", %{customer: customer}) do
    %{
      customer_id: customer.id,
      name: customer.name,
      bill_id: customer.bill_id,
      customer_table_id: customer.customer_table_id
    }
  end
end
