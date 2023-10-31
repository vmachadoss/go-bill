defmodule GoBillManagerWeb.BillControllerTest do
  use GoBillManagerWeb.ConnCase

  setup do
    %{id: employee_id} = insert(:employee)
    bill = insert(:bill, employee_id: employee_id)
    %{employee_id: employee_id, bill: bill}
  end

  describe "POST /api/v1/bills/bill" do
    test "should return a map with bill_id, total_price and state when params are valid", ctx do
      request_body =
        :bill
        |> string_params_for(employee_id: ctx.employee_id)
        |> Map.take(["employee_id", "total_price", "state"])

      conn = post(ctx.conn, Routes.bills_bill_path(ctx.conn, :create), request_body)
      response = json_response(conn, 200)

      assert response["total_price"] == request_body["total_price"]
      assert response["state"] == request_body["state"]
    end

    test "should return error when params are invalid", ctx do
      request_body = %{"employee_id" => ctx.employee_id, "total_price" => "invalid", "state" => 1}

      {conn, log} =
        with_log(fn -> post(ctx.conn, Routes.bills_bill_path(ctx.conn, :create), request_body) end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_params"}
      assert conn.status == 400
      assert log =~ "[error] Creation failed on step: bill_create"
    end

    test "should return error when employee not exists", ctx do
      request_body = %{
        "employee_id" => Ecto.UUID.generate(),
        "total_price" => "invalid",
        "state" => 1
      }

      {conn, log} =
        with_log(fn -> post(ctx.conn, Routes.bills_bill_path(ctx.conn, :create), request_body) end)

      response = json_response(conn, 404)

      assert response == %{"type" => "error:employee_not_found_or_exists"}
      assert conn.status == 404

      assert log =~
               "[error] Creation failed on step: verify_if_employee_exists, for reason: :employee_not_found"
    end
  end

  describe "GET /api/v1/bills/bill/:bill_id" do
    test "should return 400 when bill_id doesn't an uuid", %{conn: conn} do
      bill_id = -1

      conn = get(conn, Routes.bills_bill_path(conn, :show, bill_id))
      response = json_response(conn, 400)

      assert %{"type" => "error:invalid_bill_id"} == response
    end

    test "should return 404 when bill doesn't exists", %{conn: conn} do
      bill_id = Ecto.UUID.generate()

      conn = get(conn, Routes.bills_bill_path(conn, :show, bill_id))
      response = json_response(conn, 404)

      assert %{"type" => "error:bill_not_found"} == response
    end

    test "should return a bill", ctx do
      conn = get(ctx.conn, Routes.bills_bill_path(ctx.conn, :show, ctx.bill.id))
      response = json_response(conn, 200)

      assert ctx.bill.id == Map.get(response, "id")
      assert ctx.bill.total_price == Map.get(response, "total_price")
      assert Atom.to_string(ctx.bill.state) == Map.get(response, "state")
      assert ctx.employee_id == Map.get(response, "employee_id")
    end
  end
end
