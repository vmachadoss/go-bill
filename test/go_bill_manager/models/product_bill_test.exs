defmodule GoBillManager.Models.ProductBillTest do
  use GoBillManager.DataCase

  alias GoBillManager.Models.ProductBill

  @test_foreign_key_error %{
    "bill_id" => "bills_id_fk",
    "product_id" => "products_id_fk"
  }

  describe "create_changeset/2" do
    test "should return invalid changeset when missing required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = ProductBill.create_changeset(%{})

      assert %{bill_id: ["can't be blank"], product_id: ["can't be blank"]} ==
               errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      product_bill_params = params_for(:product_bill, bill_id: -1, product_id: -1)

      assert %Ecto.Changeset{valid?: false} =
               changeset = ProductBill.create_changeset(product_bill_params)

      assert %{bill_id: ["is invalid"], product_id: ["is invalid"]} == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      product_bill_params = params_for(:product_bill)

      assert %Ecto.Changeset{changes: changes, valid?: true} =
               ProductBill.create_changeset(product_bill_params)

      assert product_bill_params.bill_id == changes.bill_id
      assert product_bill_params.product_id == changes.product_id
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
                }} = ProductBill.create_changeset(product_bill_params) |> Repo.insert()
      end
    end)
  end

  defp prepare_constraint_error(key, constraint_name),
    do: [
      {String.to_existing_atom(key),
       {"does not exist", [constraint: :foreign, constraint_name: constraint_name]}}
    ]
end
