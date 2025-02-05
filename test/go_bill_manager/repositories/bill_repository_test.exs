defmodule GoBillManager.Repositories.BillRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Models.Bill
  alias GoBillManager.Repositories.BillRepository

  describe "find/1" do
    test "should return error when bill not exists" do
      bill_id = Ecto.UUID.generate()
      assert {:error, :bill_not_found} == BillRepository.find(bill_id)
    end

    test "should return bill when exists" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)

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

    test "should return bill when exists" do
      %{id: employee_id} = insert(:employee)
      %{id: bill_id} = insert(:bill, employee_id: employee_id)

      assert %Bill{id: ^bill_id} = BillRepository.find!(bill_id)
    end
  end

  describe "list_bills/0" do
    test "should return error when bills doesn't exists" do
      assert [] = BillRepository.list_bills()
    end

    test "should return bills" do
      %{id: employee_id} = insert(:employee)
      now = NaiveDateTime.utc_now()
      %{id: bill_id1} = insert(:bill, inserted_at: now, employee_id: employee_id)

      %{id: bill_id2} =
        insert(:bill, inserted_at: NaiveDateTime.add(now, 10), employee_id: employee_id)

      %{id: bill_id3} =
        insert(:bill, inserted_at: NaiveDateTime.add(now, 20), employee_id: employee_id)

      %{id: product_id} = insert(:product)
      %{id: product_id2} = insert(:product)
      insert(:product_bill, bill_id: bill_id1, product_id: product_id)
      insert(:product_bill, bill_id: bill_id1, product_id: product_id2)

      assert [
               %Bill{id: ^bill_id3},
               %Bill{id: ^bill_id2},
               %Bill{id: ^bill_id1}
             ] = BillRepository.list_bills() |> dbg()
    end
  end
end
