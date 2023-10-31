defmodule GoBillManagerWeb.BillView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{bill: bill}) do
    bill
    |> Map.put(:bill_id, bill.id)
    |> Map.take([:bill_id, :total_price, :state])
  end

  def render("simplified_bill.json", %{bill: bill}) do
    %{
      id: bill.id,
      total_price: bill.total_price,
      state: bill.state,
      employee_id: bill.employee_id
    }
  end
end
