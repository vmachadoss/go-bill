defmodule GoBillManager.Repositories.BillRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Models.Bill
  alias GoBillManager.Repositories.BillRepository

  setup do
    %{id: employee_id} = insert(:employee)
    %{id: bill_id} = insert(:bill, employee_id: employee_id)

    %{bill_id: bill_id}
  end

  describe "find/1" do
    test "should return error when bill not exists" do
      bill_id = Ecto.UUID.generate()
      assert {:error, :bill_not_found} == BillRepository.find(bill_id)
    end

    test "should return bill when exists", %{bill_id: bill_id} do
      assert {:ok, %Bill{id: ^bill_id}} = BillRepository.find(bill_id)
    end
  end

  describe "find!/1" do
    test "should return raise an NoResultsError when bill not exists" do
      bill_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        BillRepository.find!(bill_id)
      end
    end

    test "should return bill when exists", %{bill_id: bill_id} do
      assert %Bill{id: ^bill_id} = BillRepository.find!(bill_id)
    end
  end
end
