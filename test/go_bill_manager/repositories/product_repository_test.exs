defmodule GoBillManager.Repositories.ProductRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Models.Product
  alias GoBillManager.Repositories.ProductRepository

  describe "find/1" do
    test "should return error when product not exists" do
      product_id = Ecto.UUID.generate()

      assert {:error, :product_not_found} = ProductRepository.find(product_id)
    end

    test "should return product when exists" do
      %{id: product_id} = insert(:product)

      assert {:ok, %Product{id: ^product_id}} = ProductRepository.find(product_id)
    end
  end

  describe "find!/1" do
    test "should return error when product not exists" do
      product_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        ProductRepository.find!(product_id)
      end
    end

    test "should return product when exists" do
      %{id: product_id} = insert(:product)

      assert %Product{id: ^product_id} = ProductRepository.find!(product_id)
    end
  end

  describe "list_products/0" do
    test "should return error when product doesn't exists" do
      assert [] = ProductRepository.list_products()
    end

    test "should return product" do
      now = NaiveDateTime.utc_now()
      %{id: product_id1} = insert(:product, inserted_at: now)
      %{id: product_id2} = insert(:product, inserted_at: NaiveDateTime.add(now, 10))
      %{id: product_id3} = insert(:product, inserted_at: NaiveDateTime.add(now, 20))

      assert [
               %Product{id: ^product_id3},
               %Product{id: ^product_id2},
               %Product{id: ^product_id1}
             ] = ProductRepository.list_products()
    end
  end
end
