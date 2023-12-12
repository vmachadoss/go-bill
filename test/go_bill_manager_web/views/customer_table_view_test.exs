defmodule GoBillManagerWeb.CustomerTableViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Repositories.CustomerTableRepository
  alias GoBillManagerWeb.CustomerTableView

  describe "render/2 create.json" do
    test "with success response" do
      customer_table = insert(:customer_table)

      rendered_response =
        CustomerTableView.render("create.json", %{customer_table: customer_table})

      assert customer_table.id == rendered_response.customer_table_id
      assert customer_table.label == rendered_response.label
      assert customer_table.state == rendered_response.state
    end
  end

  describe "render/2 index.json" do
    test "with success response" do
      customer_table = insert(:customer_table)

      assert customer_tables = CustomerTableRepository.list_customer_tables()

      rendered_response =
        CustomerTableView.render("index.json", %{customer_tables: customer_tables})

      assert length(rendered_response) == 1

      assert resp_customer_table = Enum.at(rendered_response, 0)
      assert customer_table.id == resp_customer_table.id
      assert customer_table.label == resp_customer_table.label
      assert customer_table.state == resp_customer_table.state
    end

    test "without customer_tables" do
      assert customer_tables = CustomerTableRepository.list_customer_tables()

      rendered_response =
        CustomerTableView.render("index.json", %{customer_tables: customer_tables})

      assert [] == rendered_response
    end
  end

  describe "render/2 simplified_customer_table.json" do
    test "with success response" do
      customer_table = insert(:customer_table)

      rendered_response =
        CustomerTableView.render("simplified_customer_table.json", %{
          customer_table: customer_table
        })

      assert customer_table.id == rendered_response.id
      assert customer_table.label == rendered_response.label
      assert customer_table.state == rendered_response.state
    end
  end
end
