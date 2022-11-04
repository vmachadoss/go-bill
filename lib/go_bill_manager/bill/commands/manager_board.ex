defmodule GoBillManager.Bill.Commands.ManagerBoard do
  @moduledoc """
  Command for creating a new board
  """

  alias GoBillManager.Bill.Aggregate.BoardAggregate

  @spec run(map()) :: nil
  def run(params) do
    params
    |> BoardAggregate.create_board()
    |> dbg()
  end
end
