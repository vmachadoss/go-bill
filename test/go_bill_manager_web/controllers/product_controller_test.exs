defmodule GoBillManagerWeb.ProductControllerTest do
  use GoBillManagerWeb.ConnCase

  describe "POST /api/v1/products/product" do
    test "should return a map with product_id, name, retail_price and description when params are valid",
         ctx do
      request_body =
        :product
        |> string_params_for()
        |> Map.take(["retail_price", "name", "description"])

      conn = post(ctx.conn, Routes.products_product_path(ctx.conn, :create), request_body)
      response = json_response(conn, 200)

      assert response["name"] == request_body["name"]
      assert response["retail_price"] == request_body["retail_price"]
      assert response["description"] == request_body["description"]
    end

    test "should return error when params are invalid", ctx do
      request_body = %{"retail_price" => "invalid", "name" => 1, "description" => -1}

      {conn, log} =
        with_log(fn ->
          post(ctx.conn, Routes.products_product_path(ctx.conn, :create), request_body)
        end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_params"}
      assert conn.status == 400
      assert log =~ "[error] Creation failed on step: product_create"
    end
  end

  describe "GET /api/v1/products/product" do
    test "should return a empty list when products doesn't exists", %{conn: conn} do
      conn = get(conn, Routes.products_product_path(conn, :index))
      response = json_response(conn, 200)

      assert conn.status == 200
      assert response == []
    end

    test "should return products list", %{conn: conn} do
      now = NaiveDateTime.utc_now()
      insert(:product, inserted_at: now)
      insert(:product, inserted_at: NaiveDateTime.add(now, 10))
      insert(:product, inserted_at: NaiveDateTime.add(now, 20))

      conn = get(conn, Routes.products_product_path(conn, :index))
      response = json_response(conn, 200)

      assert length(response) == 3
    end
  end

  describe "GET /api/v1/products/product/:product_id" do
    test "should return 400 when product_id doesn't an uuid", %{conn: conn} do
      product_id = -1

      conn = get(conn, Routes.products_product_path(conn, :show, product_id))
      response = json_response(conn, 400)

      assert %{"type" => "error:invalid_product_id"} == response
    end

    test "should return 404 when product doesn't exists", %{conn: conn} do
      product_id = Ecto.UUID.generate()

      conn = get(conn, Routes.products_product_path(conn, :show, product_id))
      response = json_response(conn, 404)

      assert %{"type" => "error:product_not_found"} == response
    end

    test "should return a product", ctx do
      %{id: product_id} = product = insert(:product)

      conn = get(ctx.conn, Routes.products_product_path(ctx.conn, :show, product_id))
      response = json_response(conn, 200)

      assert product_id == Map.get(response, "id")
      assert product.retail_price == Map.get(response, "retail_price")
      assert product.description == Map.get(response, "description")
      assert product.name == Map.get(response, "name")
    end
  end

  describe "POST /api/v1/products/product_bill" do
    test "should return a map when params are valid",
         ctx do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :open, employee_id: employee_id)
      %{id: product_id} = insert(:product)

      request_body = %{"bill_id" => bill_id, "product_id" => product_id}

      conn =
        post(ctx.conn, Routes.products_product_bill_path(ctx.conn, :product_bill), request_body)

      response = json_response(conn, 200)

      assert response["bill_id"] == request_body["bill_id"]
      assert response["product_id"] == request_body["product_id"]
    end

    test "should return error when product not found", ctx do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :open, employee_id: employee_id)

      request_body = %{"bill_id" => bill_id, "product_id" => Faker.UUID.v4()}

      {conn, log} =
        with_log(fn ->
          post(ctx.conn, Routes.products_product_bill_path(ctx.conn, :product_bill), request_body)
        end)

      response = json_response(conn, 404)

      assert response == %{"type" => "error:product_not_found"}
      assert conn.status == 404
      assert log =~ "[error] Creation of product bill failed by reason:product_not_found"
    end

    test "should return error when bill not found", ctx do
      request_body = %{"bill_id" => Faker.UUID.v4(), "product_id" => Faker.UUID.v4()}

      {conn, log} =
        with_log(fn ->
          post(ctx.conn, Routes.products_product_bill_path(ctx.conn, :product_bill), request_body)
        end)

      response = json_response(conn, 404)

      assert response == %{"type" => "error:bill_not_found"}
      assert conn.status == 404
      assert log =~ "[error] Creation of product bill failed by reason:bill_not_found"
    end

    test "should return error when bill isnt open", ctx do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :close, employee_id: employee_id)

      request_body = %{"bill_id" => bill_id, "product_id" => Faker.UUID.v4()}

      {conn, log} =
        with_log(fn ->
          post(ctx.conn, Routes.products_product_bill_path(ctx.conn, :product_bill), request_body)
        end)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:bill_isnt_opened"}
      assert conn.status == 400
      assert log =~ "[error] Creation of product bill failed because the bill isn't open"
    end

    test "should return error when ids are invalid", ctx do
      request_body = %{"bill_id" => -1, "product_id" => -1}

      conn =
        post(ctx.conn, Routes.products_product_bill_path(ctx.conn, :product_bill), request_body)

      response = json_response(conn, 400)

      assert response == %{"type" => "error:invalid_uuid"}
      assert conn.status == 400
    end
  end
end
