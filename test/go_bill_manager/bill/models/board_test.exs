defmodule GoBillManager.Bill.Models.BoardTest do
  use GoBillManager.DataCase, async: true

  alias GoBillManager.Bill.Models.Board

  describe "changeset/2" do
    test "should return invalid changeset when missin required params" do
      assert %Ecto.Changeset{valid?: false} = changeset = Board.changeset(%{})

      assert %{
               number_of_customers: ["can't be blank"],
               status: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "should return invalid changeset when params are invalid" do
      board_params = %{
        number_of_customers: "invalid",
        status: "invalid",
        bill: "invalid"
      }

      assert %Ecto.Changeset{valid?: false} = changeset = Board.changeset(board_params)

      assert %{
               number_of_customers: ["is invalid"],
               status: ["is invalid"]
             } == errors_on(changeset)
    end

    test "should return valid changeset when params are valid" do
      board_params = %{
        number_of_customers: 5,
        status: "available"
      }

      assert %Ecto.Changeset{changes: changes, valid?: true} = Board.changeset(board_params)

      assert board_params.number_of_customers == changes.number_of_customers
      assert board_params.status == Atom.to_string(changes.status)
    end
  end
end
