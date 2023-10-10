defmodule GoBillManager.Repositories.EmployeeRepositoryTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Aggregates.Employee
  alias GoBillManager.Models.Employee
  alias GoBillManager.Repositories.EmployeeRepository

  describe "find/1" do
    test "should return error when employee not exists" do
      employee_id = Ecto.UUID.generate()

      assert {:error, :employee_not_found} = EmployeeRepository.find(employee_id)
    end

    test "should return employee when exists" do
      %{id: employee_id} = insert(:employee)

      assert {:ok, %Employee{id: ^employee_id}} = EmployeeRepository.find(employee_id)
    end
  end

  describe "find!/1" do
    test "should return error when employee not exists" do
      employee_id = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        EmployeeRepository.find!(employee_id)
      end
    end

    test "should return employee when exists" do
      %{id: employee_id} = insert(:employee)

      assert %Employee{id: ^employee_id} = EmployeeRepository.find!(employee_id)
    end
  end

  describe "list_employees/0" do
    test "should return error when employees doesn't exists" do
      assert {:error, :employees_not_found} = EmployeeRepository.list_employees()
    end

    test "should return employees" do
      now = NaiveDateTime.utc_now()
      %{id: employee_id1} = insert(:employee, inserted_at: now)
      %{id: employee_id2} = insert(:employee, inserted_at: NaiveDateTime.add(now, 10))
      %{id: employee_id3} = insert(:employee, inserted_at: NaiveDateTime.add(now, 20))

      assert {:ok,
              [
                %Employee{id: ^employee_id3},
                %Employee{id: ^employee_id2},
                %Employee{id: ^employee_id1}
              ]} = EmployeeRepository.list_employees() |> dbg()
    end
  end
end
