defmodule GoBillManager.Bill.Commands.ManagerBoardTest do
  @moduledoc false

  use GoBillManager.DataCase
  alias GoBillManager.Bill.Commands.ManagerBoard
  alias GoBillManager.Bill.Models.Board

  describe "run/1" do
    test "bacanudo" do
      params = string_params_for(:create_board)

      assert {:ok,
              %Board{
                number_of_customers: response_number_of_customers,
                status: response_status
              }} = CreateBoard.run(params)

      assert params["number_of_customers"] == response_number_of_customers
      assert params["status"] == response_status

      assert Repo.aggregate(Board, :count, :id) == 1
    end
  end
end
