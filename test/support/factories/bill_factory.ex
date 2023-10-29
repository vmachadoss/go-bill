defmodule GoBillManager.BillFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Models.Bill

      def bill_factory(params \\ %{}) do
        merge_attributes(
          %Bill{
            id: Ecto.UUID.generate(),
            total_price: Enum.random(1..999),
            state: Enum.random(~w/open close/),
            employee_id: Ecto.UUID.generate()
          },
          params
        )
      end
    end
  end
end
