defmodule GoBillManagerWeb.BillViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManagerWeb.BillView

  describe "render/2 create.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      bill = insert(:bill, employee_id: employee_id)

      rendered_response = BillView.render("create.json", %{bill: bill})

      assert bill.id == rendered_response.bill_id
      assert bill.total_price == rendered_response.total_price
      assert bill.state == rendered_response.state
    end
  end
end
