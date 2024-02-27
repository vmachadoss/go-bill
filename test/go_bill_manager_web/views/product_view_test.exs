defmodule GoBillManagerWeb.ProductViewTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Repositories.ProductRepository
  alias GoBillManagerWeb.ProductView

  describe "render/2 create.json" do
    test "with success response" do
      product = insert(:product)

      rendered_response = ProductView.render("create.json", %{product: product})

      assert product.id == rendered_response.product_id
      assert product.name == rendered_response.name
      assert product.retail_price == rendered_response.retail_price
      assert product.description == rendered_response.description
    end
  end

  describe "render/2 index.json" do
    test "with success response" do
      product = insert(:product)

      assert products = ProductRepository.list_products()

      rendered_response = ProductView.render("index.json", %{products: products})

      assert length(rendered_response) == 1

      assert resp_product = Enum.at(rendered_response, 0)
      assert product.id == resp_product.id
      assert product.name == resp_product.name
      assert product.retail_price == resp_product.retail_price
      assert product.description == resp_product.description
    end

    test "without products" do
      assert products = ProductRepository.list_products()

      rendered_response = ProductView.render("index.json", %{products: products})

      assert [] == rendered_response
    end
  end

  describe "render/2 simplified_product.json" do
    test "with success response" do
      product = insert(:product)

      rendered_response = ProductView.render("simplified_product.json", %{product: product})

      assert product.id == rendered_response.id
      assert product.name == rendered_response.name
      assert product.retail_price == rendered_response.retail_price
      assert product.description == rendered_response.description
    end
  end
end
