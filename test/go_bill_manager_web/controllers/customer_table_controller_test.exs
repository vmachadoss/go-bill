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

  describe "GET /api/v1/customer_tables/customer_table/:customer_table_id" do
    test "should return 400 when customer_table_id doesn't an uuid", %{conn: conn} do
      customer_table_id = -1

      conn = get(conn, Routes.customer_tables_customer_table_path(conn, :show, customer_table_id))
      response = json_response(conn, 400)

      assert %{"type" => "error:invalid_customer_table_id"} == response
    end

    test "should return 404 when customer_table doesn't exists", %{conn: conn} do
      customer_table_id = Ecto.UUID.generate()

      conn = get(conn, Routes.customer_tables_customer_table_path(conn, :show, customer_table_id))
      response = json_response(conn, 404)

      assert %{"type" => "error:customer_table_not_found"} == response
    end

    test "should return an customer_table", %{conn: conn} do
      %{id: customer_table_id, label: label, state: state} = insert(:customer_table)

      conn = get(conn, Routes.customer_tables_customer_table_path(conn, :show, customer_table_id))
      response = json_response(conn, 200)

      assert customer_table_id == Map.get(response, "id")
      assert label == Map.get(response, "label")
      assert Atom.to_string(state) == Map.get(response, "state")
    end
  end
end
