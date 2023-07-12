defmodule GoBillManager.ProductFactory do
@moduledoc false

defmacro __using__(_opts) do
  quote location: :keep do
    alias GoBillManager.Models.Product

    def product_factory(params \\ %{}) do
      merge_attributes(%Product{
        id: Ecto.UUID.generate(),
        name: "Cerveja",
        retail_price: Enum.random(1..100),
        description: "Descrição maneira",
        inserted_at: NaiveDateTime.utc_now()
      }, params)
    end
  end
end
end
