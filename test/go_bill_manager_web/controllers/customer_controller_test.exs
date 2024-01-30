defmodule GoBillManagerWeb.CustomerControllerTest do
  use GoBillManagerWeb.ConnCase

  describe "POST /api/v1/customers/customer" do
    test "should return a map with customer_id, name, bill_id and customer_table_id when params are valid",
         %{
           conn: conn
         } do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      request_body =
        :customer
        |> string_params_for()
        |> Map.put("bill_id", bill_id)
        |> Map.put("customer_table_id", customer_table_id)
        |> Map.take(["id", "name", "bill_id", "customer_table_id"])

      conn = post(conn, Routes.customers_customer_path(conn, :create), request_body)
      response = json_response(conn, 200)

      assert response["name"] == request_body["name"]
      assert response["state"] == request_body["state"]
      assert response["bill_id"] == request_body["bill_id"]
      assert response["customer_table_id"] == request_body["customer_table_id"]
    end

    test "should return error when params are invalid", %{conn: conn} do
      request_body = %{
        "name" => -1,
        "bill_id" => 1,
        "customer_table_id" => 1
      }

      {conn, log} =
        with_log(fn ->
          post(conn, Routes.customers_customer_path(conn, :create), request_body)
        end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_params"}
      assert conn.status == 400
      assert log =~ "[error] Creation failed on step: customer_create"
    end
  end

  describe "GET /api/v1/customers/customer" do
    test "should return a empty list when customers doesn't exists", %{conn: conn} do
      conn = get(conn, Routes.customers_customer_path(conn, :index))
      response = json_response(conn, 200)

      assert conn.status == 200
      assert response == []
    end

    test "should return customers list", %{conn: conn} do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: bill_id2} = insert(:bill, employee_id: employee_id)
      %{id: bill_id3} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      now = NaiveDateTime.utc_now()
      insert(:customer, inserted_at: now, bill_id: bill_id, customer_table_id: customer_table_id)

      insert(:customer,
        inserted_at: NaiveDateTime.add(now, 10),
        bill_id: bill_id2,
        customer_table_id: customer_table_id
      )

      insert(:customer,
        inserted_at: NaiveDateTime.add(now, 20),
        bill_id: bill_id3,
        customer_table_id: customer_table_id
      )

      conn = get(conn, Routes.customers_customer_path(conn, :index))
      response = json_response(conn, 200)

      assert length(response) == 3
    end
  end

  describe "GET /api/v1/customers/customer/:customer_id" do
    test "should return 400 when customer_id doesn't an uuid", %{conn: conn} do
      customer_id = -1

      conn = get(conn, Routes.customers_customer_path(conn, :show, customer_id))
      response = json_response(conn, 400)

      assert %{"type" => "error:invalid_customer_id"} == response
    end

    test "should return 404 when customer doesn't exists", %{conn: conn} do
      customer_id = Ecto.UUID.generate()

      conn = get(conn, Routes.customers_customer_path(conn, :show, customer_id))
      response = json_response(conn, 404)

      assert %{"type" => "error:customer_not_found"} == response
    end

    test "should return an customer", %{conn: conn} do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      %{id: customer_id, name: name, bill_id: bill_id, customer_table_id: customer_table_id} =
        insert(:customer, bill_id: bill_id, customer_table_id: customer_table_id)

      conn = get(conn, Routes.customers_customer_path(conn, :show, customer_id))
      response = json_response(conn, 200)

      assert customer_id == Map.get(response, "customer_id")
      assert name == Map.get(response, "name")
      assert bill_id == Map.get(response, "bill_id")
      assert customer_table_id == Map.get(response, "customer_table_id")
    end
  end
end
