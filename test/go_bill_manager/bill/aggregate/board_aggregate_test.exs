defmodule GoBillManager.Bill.Aggregate.BoardAggregateTest do
  @moduledoc false
  use GoBillManager.DataCase

  alias GoBillManager.Bill.Aggregate.BoardAggregate
  alias GoBillManager.Bill.Models.Board

  describe "create_board/1" do
    test "return error, changeset when params are invalid" do
      board_params =
        string_params_for(:create_board, number_of_customers: "invalid", status: "invalid")

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               BoardAggregate.create_board(board_params)

      assert %{
               number_of_customers: ["is invalid"],
               status: ["is invalid"]
             } == errors_on(changeset)

      assert Repo.aggregate(Board, :count, :id) == 0
    end

    test "should return error, changeset invalid when params are empties" do
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               BoardAggregate.create_board(%{})

      assert %{
               number_of_customers: ["can't be blank"],
               status: ["can't be blank"]
             } == errors_on(changeset)

      assert Repo.aggregate(Board, :count, :id) == 0
    end

    test "should return a valid ok and changeset when the params are valid" do
      board_params = string_params_for(:create_board)

      assert {:ok, %Board{}} = BoardAggregate.create_board(board_params)

      assert Repo.aggregate(Board, :count, :id) == 1
    end
  end
end
