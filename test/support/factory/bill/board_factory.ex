defmodule GoBillManager.BoardFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Bill.Models.Board

      def create_board_factory(params \\ %{}) do
        merge_attributes(
          %Board{
            id: Ecto.UUID.generate(),
            number_of_customers: Enum.random(1..20),
            status: Enum.random(~w(occupated available cleaning)a),
            inserted_at: DateTime.utc_now()
          },
          params
        )
      end
    end
  end
end
