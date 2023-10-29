defmodule GoBillManagerWeb.BillControllerTest do
  use GoBillManagerWeb.ConnCase

  describe "POST /api/v1/bills/bill" do
    setup do
      %{id: employee_id} = insert(:employee)

      %{employee_id: employee_id}
    end

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
  end
end
