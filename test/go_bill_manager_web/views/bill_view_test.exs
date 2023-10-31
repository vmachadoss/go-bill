defmodule GoBillManagerWeb.BillViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManagerWeb.BillView

  setup do
    %{id: employee_id} = insert(:employee)
    bill = insert(:bill, employee_id: employee_id)

    %{bill: bill, employee_id: employee_id}
  end

  describe "render/2 create.json" do
    test "with success response", %{bill: bill} do
      rendered_response = BillView.render("create.json", %{bill: bill})

      assert bill.id == rendered_response.bill_id
      assert bill.total_price == rendered_response.total_price
      assert bill.state == rendered_response.state
    end
  end

  describe "render/2 simplified_bill.json" do
    test "with success response", %{bill: bill, employee_id: employee_id} do
      rendered_response = BillView.render("simplified_bill.json", %{bill: bill})

      assert bill.id == rendered_response.id
      assert bill.total_price == rendered_response.total_price
      assert bill.state == rendered_response.state
      assert ^employee_id = rendered_response.employee_id
    end
  end
end
