defmodule GoBillManager.BillFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Bill.Models.Bill

      def create_bill_factory(params \\ %{}) do
        merge_attributes(
          %Bill{
            id: Ecto.UUID.generate(),
            amount: Enum.random(1..5000),
            consumables: %{},
            status: Enum.random([:open, :close]),
            board_id: Ecto.UUID.generate(),
            employee_id: Ecto.UUID.generate()
          },
          params
        )
      end
    end
  end
end
