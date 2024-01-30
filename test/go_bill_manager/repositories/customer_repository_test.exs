defmodule GoBillManager.Repositories.CustomerRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Models.Customer
  alias GoBillManager.Repositories.CustomerRepository

  setup do
    %{id: employee_id} = insert(:employee)
    %{id: bill_id} = insert(:bill, employee_id: employee_id)
    %{id: customer_table_id} = insert(:customer_table)
    %{id: customer_id} = insert(:customer, customer_table_id: customer_table_id, bill_id: bill_id)

    %{customer_id: customer_id}
  end

  describe "find/1" do
    test "should return error when customer not exists" do
      customer_id = Ecto.UUID.generate()

      assert {:error, :customer_not_found} = CustomerRepository.find(customer_id)
    end

    test "should return customer when exists", context do
      assert {:ok, %Customer{}} = CustomerRepository.find(context.customer_id)
    end
  end

  describe "find!/1" do
    test "should return error when customer not exists" do
      customer_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        CustomerRepository.find!(customer_id)
      end
    end

    test "should return customer when exists", context do
      assert %Customer{} = CustomerRepository.find!(context.customer_id)
    end
  end

  describe "list_customers/0" do
    test "should return error when customer doesn't exists" do
      assert [] = CustomerRepository.list_customers()
    end

    test "should return customer" do
      now = NaiveDateTime.utc_now()
      %{id: employee_id} = insert(:employee)
      %{id: bill_id1} = insert(:bill, employee_id: employee_id)
      %{id: bill_id2} = insert(:bill, employee_id: employee_id)
      %{id: bill_id3} = insert(:bill, employee_id: employee_id)
      %{id: customer_table_id} = insert(:customer_table)

      %{id: customer_id1} =
        insert(:customer,
          customer_table_id: customer_table_id,
          bill_id: bill_id1,
          inserted_at: now
        )

      %{id: customer_id2} =
        insert(:customer,
          customer_table_id: customer_table_id,
          bill_id: bill_id2,
          inserted_at: NaiveDateTime.add(now, 10)
        )

      %{id: customer_id3} =
        insert(:customer,
          customer_table_id: customer_table_id,
          bill_id: bill_id3,
          inserted_at: NaiveDateTime.add(now, 20)
        )

      assert [
               %Customer{id: ^customer_id3},
               %Customer{id: ^customer_id2},
               %Customer{id: ^customer_id1}
             ] = CustomerRepository.list_customers()
    end
  end
end
