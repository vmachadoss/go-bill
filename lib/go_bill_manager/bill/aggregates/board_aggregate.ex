defmodule GoBillManager.Bill.Aggregate.BoardAggregate do
  @moduledoc """
  This aggregate module take care of Board insertions, update and delete operations
  """

  alias GoBillManager.Bill.Models.Board
  alias GoBillManager.Repo

  @spec create_board(map()) :: Board.t()
  def create_board(board_params) do
    board_params
    |> Board.changeset()
    |> Repo.insert()
  end
end
