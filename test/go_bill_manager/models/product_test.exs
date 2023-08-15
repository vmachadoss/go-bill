defmodule GoBillManager.Models.ProductTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.Product

  describe "changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Product.create_changeset(%{})

      assert %{
               name: ["can't be blank"],
               retail_price: ["can't be blank"],
               description: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      product_params = params_for(:product, name: -1, retail_price: "invalid", description: -1)

      assert %Ecto.Changeset{valid?: false} = changeset = Product.create_changeset(product_params)

      assert %{
               name: ["is invalid"],
               retail_price: ["is invalid"],
               description: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      product_params = params_for(:product)

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               Product.create_changeset(product_params)

      assert product_params.name == changes.name
      assert product_params.description == changes.description
      assert product_params.retail_price == changes.retail_price
    end
  end
end
