defmodule GoBillManagerWeb.EmployeeControllerTest do
  use GoBillManagerWeb.ConnCase

  describe "POST /api/v1/employees/employee" do
    test "should return a map with employee_id, name and role when params are valid", %{
      conn: conn
    } do
      request_body =
        :employee
        |> string_params_for()
        |> Map.take(["name", "role"])

      conn = post(conn, ~p(/api/v1/employees/employee), request_body)

      response = json_response(conn, 200)

      assert request_body["name"] == response["name"]
      assert request_body["role"] == response["role"]
    end

    test "should return error when params are invalid", context do
      request_body = %{"name" => -1, "role" => -1}

      {conn, log} =
        with_log(fn ->
          post(context.conn, Routes.employees_employee_path(context.conn, :create), request_body)
        end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_params"}
      assert conn.status == 400
      assert log =~ "[error] Creation failed on step: employee_create"
    end
  end

  describe "GET /api/v1/employees/employee" do
    test "should return a empty list when employees doesn't exists", %{conn: conn} do
      conn = get(conn, Routes.employees_employee_path(conn, :index))
      response = json_response(conn, 200)

      assert conn.status == 200
      assert response == []
    end

    test "should return employees list", %{conn: conn} do
      now = NaiveDateTime.utc_now()
      insert(:employee, inserted_at: now)
      insert(:employee, inserted_at: NaiveDateTime.add(now, 10))
      insert(:employee, inserted_at: NaiveDateTime.add(now, 20))

      conn = get(conn, Routes.employees_employee_path(conn, :index))
      response = json_response(conn, 200)

      assert length(response) == 3
    end
  end

  describe "GET /api/v1/employees/employee/:employee_id" do
    test "should return 400 when employee_id doesn't an uuid", %{conn: conn} do
      employee_id = -1

      conn = get(conn, Routes.employees_employee_path(conn, :show, employee_id))
      response = json_response(conn, 400)

      assert %{"type" => "error:invalid_employee_id"} == response
    end

    test "should return 404 when employee doesn't exists", %{conn: conn} do
      employee_id = Ecto.UUID.generate()

      conn = get(conn, Routes.employees_employee_path(conn, :show, employee_id))
      response = json_response(conn, 404)

      assert %{"type" => "error:employee_not_found"} == response
    end

    test "should return an employee", %{conn: conn} do
      %{id: employee_id, name: name, role: role} = insert(:employee)

      conn = get(conn, Routes.employees_employee_path(conn, :show, employee_id))
      response = json_response(conn, 200)

      assert employee_id == Map.get(response, "id")
      assert name == Map.get(response, "name")
      assert Atom.to_string(role) == Map.get(response, "role")
    end
  end
end
