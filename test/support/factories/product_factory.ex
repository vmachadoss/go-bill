defmodule GoBillManager.ProductFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote location: :keep do
      alias GoBillManager.Models.Product
      alias GoBillManager.Models.ProductBill

      def product_factory do
        %Product{
          id: Ecto.UUID.generate(),
          name: "Cerveja",
          retail_price: Enum.random(1..100),
          description: "Descrição maneira",
          inserted_at: NaiveDateTime.utc_now()
        }
      end

      def product_bill_factory do
        %ProductBill{}
      end
    end
  end
end
