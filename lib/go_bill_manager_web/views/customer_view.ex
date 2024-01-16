defmodule GoBillManagerWeb.CustomerView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{customer: customer}) do
    customer
    |> Map.put(:customer_id, customer.id)
    |> Map.take([:customer_id, :label, :state])
  end

  def render("index.json", %{customers: customers}) do
    render_many(customers, __MODULE__, "simplified_customer.json",
      as: :customer
    )
  end

  def render("simplified_customer.json", %{customer: customer}) do
    %{
      id: customer.id,
      label: customer.label,
      state: customer.state
    }
  end
end
