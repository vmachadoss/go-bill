defmodule GoBillManager.Commands.ProductCreateTest do
  use GoBillManager.DataCase

  alias GoBillManager.Commands.ProductCreate
  alias GoBillManager.Models.Product

  describe "run/1" do
    test "should return error when params are required" do
      {{:error, invalid_changeset}, log} = with_log(fn -> ProductCreate.run(%{}) end)

      assert errors_on(invalid_changeset) == %{
               name: ["can't be blank"],
               description: ["can't be blank"],
               retail_price: ["can't be blank"]
             }

      assert log =~ ~s/[error] Creation failed on step: product_create, for reason: /
    end

    test "should return error when params are invalid" do
      {{:error, invalid_changeset}, log} =
        with_log(fn ->
          ProductCreate.run(%{"name" => -1, "description" => -1, "retail_price" => "invalid"})
        end)

      assert errors_on(invalid_changeset) == %{
               description: ["is invalid"],
               name: ["is invalid"],
               retail_price: ["is invalid"]
             }

      assert log =~ ~s/[error] Creation failed on step: product_create, for reason: /
    end

    test "should return ok and result when params are valid" do
      %{
        "name" => product_name,
        "retail_price" => product_retail_price,
        "description" => product_description
      } =
        product_params =
        :product
        |> string_params_for()
        |> Map.take(["name", "retail_price", "description"])

      assert {:ok, %Product{} = resp_product} = ProductCreate.run(product_params)

      assert product_name == resp_product.name
      assert product_retail_price == resp_product.retail_price
      assert product_description == resp_product.description
    end
  end
end
