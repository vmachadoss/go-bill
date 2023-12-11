defmodule GoBillManager.CustomerFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Models.Customer
      alias GoBillManager.Models.CustomerTable

      def customer_factory(params \\ %{}) do
        merge_attributes(
          %Customer{
            id: Ecto.UUID.generate(),
            name: "Maria Juana",
            bill_id: Ecto.UUID.generate(),
            customer_table_id: Ecto.UUID.generate(),
            inserted_at: NaiveDateTime.utc_now()
          },
          params
        )
      end

      def customer_table_factory(params \\ %{}) do
        merge_attributes(
          %CustomerTable{
            id: Ecto.UUID.generate(),
            label: "1",
            state: "available",
            inserted_at: NaiveDateTime.utc_now()
          },
          params
        )
      end
    end
  end
end
