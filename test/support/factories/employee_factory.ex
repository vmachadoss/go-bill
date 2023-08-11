defmodule GoBillManager.EmployeeFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Models.Employee

      def employee_factory(params \\ %{}) do
        merge_attributes(
          %Employee{
            id: Ecto.UUID.generate(),
            name: "João Armless",
            role: Enum.random(~w/attendant manager/),
            inserted_at: NaiveDateTime.utc_now()
          },
          params
        )
      end
    end
  end
end
