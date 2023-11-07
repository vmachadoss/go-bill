defmodule GoBillManagerWeb.BillViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Repositories.BillRepository
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

  describe "render/2 index.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      bill = insert(:bill, employee_id: employee_id)

      assert bills = BillRepository.list_bills()

      rendered_response = BillView.render("index.json", %{bills: bills})

      assert length(rendered_response) == 1

      assert resp_bill = Enum.at(rendered_response, 0)
      assert bill.id == resp_bill.id
      assert bill.total_price == resp_bill.total_price
      assert bill.state == resp_bill.state
      assert bill.employee_id == resp_bill.employee_id
    end

    test "without bills" do
      assert bills = BillRepository.list_bills()

      rendered_response = BillView.render("index.json", %{bills: bills})

      assert [] == rendered_response
    end
  end

  describe "render/2 simplified_bill.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      bill = insert(:bill, employee_id: employee_id)

      rendered_response = BillView.render("simplified_bill.json", %{bill: bill})

      assert bill.id == rendered_response.id
      assert bill.total_price == rendered_response.total_price
      assert bill.state == rendered_response.state
      assert ^employee_id = rendered_response.employee_id
    end
  end
end
