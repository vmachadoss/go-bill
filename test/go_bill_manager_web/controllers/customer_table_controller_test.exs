defmodule GoBillManagerWeb.CustomerTableControllerTest do
  use GoBillManagerWeb.ConnCase

  describe "POST /api/v1/customer_tables/customer_table" do
    test "should return a map with customer_table_id, label and state when params are valid", %{
      conn: conn
    } do
      %{id: customer_table_id} = insert(:customer_table)

      request_body =
        :customer_table
        |> string_params_for(id: customer_table_id)
        |> Map.take(["customer_table_id", "label", "state"])

      conn = post(conn, Routes.customer_tables_customer_table_path(conn, :create), request_body)
      response = json_response(conn, 200)

      assert response["label"] == request_body["label"]
      assert response["state"] == request_body["state"]
    end

    test "should return error when params are invalid", %{conn: conn} do
      %{id: customer_table_id} = insert(:customer_table)

      request_body = %{
        "customer_table_id" => customer_table_id,
        "label" => "invalid",
        "state" => 1
      }

      {conn, log} =
        with_log(fn ->
          post(conn, Routes.customer_tables_customer_table_path(conn, :create), request_body)
        end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_params"}
      assert conn.status == 400
      assert log =~ "[error] Creation failed on step: customer_table_create"
    end
  end
end
