defmodule GoBillManager.Bill.Models.EmployeeTest do
  use GoBillManager.DataCase

  alias GoBillManager.Bill.Models.Employee

  describe "changeset/2" do
    test "should return invalid changeset when missin required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Employee.changeset(%{})

      assert %{
               name: ["can't be blank"],
               role: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      employee_params = %{
        name: 123,
        role: "invalid"
      }

      assert %Ecto.Changeset{valid?: false} = changeset = Employee.changeset(employee_params)

      assert %{
               name: ["is invalid"],
               role: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      employee_params = %{
        name: "Robertinho",
        role: "manager"
      }

      assert %Ecto.Changeset{changes: changes, valid?: true} = Employee.changeset(employee_params)

      assert employee_params.name == changes.name
      assert employee_params.role == Atom.to_string(changes.role)
    end
  end
end
