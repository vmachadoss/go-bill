defmodule GoBillManagerWeb.BillView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("bill_create.json", %{bill: bill}) do
    bill
    |> Map.put(:bill_id, bill.id)
    |> Map.take([:bill_id, :total_price, :state])
  end
end
