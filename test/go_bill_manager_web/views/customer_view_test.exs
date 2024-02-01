defmodule GoBillManagerWeb.CustomerViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Repositories.CustomerRepository
  alias GoBillManagerWeb.CustomerView

  describe "render/2 create.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      customer = insert(:customer, customer_table_id: customer_table_id, bill_id: bill_id)

      rendered_response = CustomerView.render("create.json", %{customer: customer})

      assert customer.id == rendered_response.customer_id
      assert customer.name == rendered_response.name
      assert customer.bill_id == rendered_response.bill_id
      assert customer.customer_table_id == rendered_response.customer_table_id
    end
  end

  describe "render/2 index.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      customer = insert(:customer, customer_table_id: customer_table_id, bill_id: bill_id)

      assert customers = CustomerRepository.list_customers()

      rendered_response = CustomerView.render("index.json", %{customers: customers})

      assert length(rendered_response) == 1

      assert resp_customer = Enum.at(rendered_response, 0)
      assert customer.id == resp_customer.customer_id
      assert customer.name == resp_customer.name
      assert customer.bill_id == resp_customer.bill_id
      assert customer.customer_table_id == resp_customer.customer_table_id
    end

    test "without customers" do
      assert customers = CustomerRepository.list_customers()

      rendered_response = CustomerView.render("index.json", %{customers: customers})

      assert [] == rendered_response
    end
  end

  describe "render/2 simplified_customer.json" do
    test "with success response" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      customer = insert(:customer, customer_table_id: customer_table_id, bill_id: bill_id)
      rendered_response = CustomerView.render("simplified_customer.json", %{customer: customer})

      assert customer.id == rendered_response.customer_id
      assert customer.name == rendered_response.name
      assert customer.bill_id == rendered_response.bill_id
      assert customer.customer_table_id == rendered_response.customer_table_id
    end
  end
end
