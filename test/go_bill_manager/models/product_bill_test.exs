defmodule GoBillManager.Models.ProductBillTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.ProductBill

  describe "changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = ProductBill.changeset(%{})

      assert %{bill_id: ["can't be blank"], product_id: ["can't be blank"]} ==
               errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      product_bill_params = params_for(:product_bill, bill_id: -1, product_id: -1)

      assert %Ecto.Changeset{valid?: false} = changeset = ProductBill.changeset(product_bill_params)

      assert %{bill_id: ["is invalid"], product_id: ["is invalid"]} == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      product_bill_params = params_for(:product_bill)

      assert %Ecto.Changeset{changes: changes, valid?: true} = ProductBill.changeset(product_bill_params)

      assert product_bill_params.bill_id == changes.bill_id
      assert product_bill_params.product_id == changes.product_id
    end
  end
end
