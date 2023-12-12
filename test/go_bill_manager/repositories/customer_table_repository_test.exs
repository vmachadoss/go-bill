defmodule GoBillManager.Repositories.CustomerTableRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Aggregates.CustomerTable
  alias GoBillManager.Models.CustomerTable
  alias GoBillManager.Repositories.CustomerTableRepository

  describe "find/1" do
    test "should return error when customer_table not exists" do
      customer_table_id = Ecto.UUID.generate()

      assert {:error, :customer_table_not_found} = CustomerTableRepository.find(customer_table_id)
    end

    test "should return customer_table when exists" do
      %{id: customer_table_id} = insert(:customer_table)

      assert {:ok, %CustomerTable{id: ^customer_table_id}} =
               CustomerTableRepository.find(customer_table_id)
    end
  end

  describe "find!/1" do
    test "should return error when customer_table not exists" do
      customer_table_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        CustomerTableRepository.find!(customer_table_id)
      end
    end

    test "should return customer_table when exists" do
      %{id: customer_table_id} = insert(:customer_table)

      assert %CustomerTable{id: ^customer_table_id} =
               CustomerTableRepository.find!(customer_table_id)
    end
  end
end
