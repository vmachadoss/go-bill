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
        %ProductBill{
          id: Ecto.UUID.generate(),
          bill_id: Ecto.UUID.generate(),
          product_id: Ecto.UUID.generate(),
          inserted_at: NaiveDateTime.utc_now(),
          updated_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
