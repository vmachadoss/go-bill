defmodule GoBillManager.EmployeeFactory do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Models.Employee

      def create_employee_factory(params \\ %{}) do
        merge_attributes(
          %Employee{
            id: Ecto.UUID.generate(),
            name: Enum.random(~w(Vitor Ronaldo José Ribeiro Timoteo)),
            role: Enum.random(~w(attendant manager)a)
          },
          params
        )
      end
    end
  end
end
