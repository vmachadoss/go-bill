defmodule GoBillManagerWeb.ProductView do
  use GoBillManagerWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("create.json", %{product: product}) do
    product
    |> Map.put(:product_id, product.id)
    |> Map.take([:product_id, :name, :retail_price, :description])
  end

  def render("index.json", %{products: products}) do
    render_many(products, __MODULE__, "simplified_product.json", as: :product)
  end

  def render("simplified_product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      retail_price: product.retail_price,
      description: product.description
    }
  end
end
