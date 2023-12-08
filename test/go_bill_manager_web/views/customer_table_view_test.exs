defmodule GoBillManagerWeb.CustomerTableViewTest do
  use GoBillManager.DataCase, async: true

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
end
