defmodule GoBillManager.Commands.ProductBillCreateTest do
  use GoBillManager.DataCase

  alias GoBillManager.Commands.ProductBillCreate
  alias GoBillManager.Models.ProductBill

  describe "run/1" do
    test "should create product bill" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :open, employee_id: employee_id)
      %{id: product_id} = insert(:product)

      params = %{"bill_id" => bill_id, "product_id" => product_id}

      assert {:ok, %ProductBill{} = product_bill} = ProductBillCreate.run(params)

      assert bill_id == product_bill.bill_id
      assert product_id == product_bill.product_id
    end

    test "should return bill not found when bill does not exist" do
      %{id: product_id} = insert(:product)

      params = %{"bill_id" => Faker.UUID.v4(), "product_id" => product_id}

      assert {{:error, :bill_not_found}, log} =
               with_log(fn -> ProductBillCreate.run(params) end)

      assert log =~ "Creation of product bill failed by reason:bill_not_found"
    end

    test "should return product not found when product does not exist" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :open, employee_id: employee_id)

      params = %{"bill_id" => bill_id, "product_id" => Faker.UUID.v4()}

      assert {{:error, :product_not_found}, log} =
               with_log(fn -> ProductBillCreate.run(params) end)

      assert log =~ "Creation of product bill failed by reason:product_not_found"
    end

    test "should return bill isn't open" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, state: :close, employee_id: employee_id)

      params = %{"bill_id" => bill_id, "product_id" => Faker.UUID.v4()}

      assert {{:error, :bill_isnt_opened}, log} =
               with_log(fn -> ProductBillCreate.run(params) end)

      assert log =~ "[error] Creation of product bill failed because the bill isn't open"
    end
  end
end
