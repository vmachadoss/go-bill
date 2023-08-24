defmodule GoBillManager.Aggregates.ProductTest do
  use GoBillManager.DataCase, async: false

  alias GoBillManager.Aggregates.Product, as: ProductAggregate
  alias GoBillManager.Models.Product
  alias GoBillManager.Models.ProductBill

  @test_foreign_key_error %{
    "bill_id" => "bills_id_fk",
    "product_id" => "products_id_fk"
  }

  describe "create/1" do
    test "should return ok with valid params" do
      %{"name" => name, "retail_price" => retail_price, "description" => description} =
        product_params = string_params_for(:product)

      assert {:ok, %Product{name: ^name, retail_price: ^retail_price, description: ^description}} =
               ProductAggregate.create(product_params)

      assert Repo.aggregate(Product, :count, :id) == 1
    end

    test "should return error when params are required" do
      assert {:error, changeset} = ProductAggregate.create(%{})

      assert %{
               name: ["can't be blank"],
               retail_price: ["can't be blank"],
               description: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return error when params are invalid" do
      product_params =
        string_params_for(:product, name: -1, retail_price: "invalid", description: -1)

      assert {:error, changeset} = ProductAggregate.create(product_params)

      assert %{
               name: ["is invalid"],
               retail_price: ["is invalid"],
               description: ["is invalid"]
             } == errors_on(changeset)
    end
  end

  describe "create_product_bill/1" do
    test "should return ok with valid params" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)
      %{id: product_id} = insert(:product)

      product_bill_params =
        string_params_for(:product_bill, bill_id: bill_id, product_id: product_id)

      assert {:ok, %ProductBill{bill_id: ^bill_id, product_id: ^product_id}} =
               ProductAggregate.create_product_bill(product_bill_params)

      assert Repo.aggregate(ProductBill, :count, :id) == 1
    end

    test "should return error when params are required" do
      assert {:error, changeset} = ProductAggregate.create_product_bill(%{})

      assert %{
               bill_id: ["can't be blank"],
               product_id: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return error when params are invalid" do
      product_bill_params = string_params_for(:product_bill, bill_id: -1, product_id: -1)

      assert {:error, changeset} = ProductAggregate.create_product_bill(product_bill_params)

      assert %{bill_id: ["is invalid"], product_id: ["is invalid"]} == errors_on(changeset)
    end

    Enum.each(@test_foreign_key_error, fn {key, _constraint_name} = map ->
      test "should return constraint error #{key} foreign key relation" do
        {key, constraint_name} = unquote(map)

        %{id: employee_id} = insert(:employee)
        %{id: bill_id} = insert(:bill, employee_id: employee_id)
        %{id: product_id} = insert(:product)

        product_bill_params =
          string_params_for(:product_bill, bill_id: bill_id, product_id: product_id)

        product_bill_params = Map.put(product_bill_params, key, Ecto.UUID.generate())

        error_message = prepare_constraint_error(key, constraint_name)

        assert {:error,
                %Ecto.Changeset{
                  valid?: false,
                  errors: ^error_message
                }} = ProductAggregate.create_product_bill(product_bill_params)
      end
    end)
  end

  defp prepare_constraint_error(key, constraint_name),
    do: [
      {String.to_existing_atom(key),
       {"does not exist", [constraint: :foreign, constraint_name: constraint_name]}}
    ]
end
