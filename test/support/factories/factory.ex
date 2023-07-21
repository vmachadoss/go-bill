defmodule GoBillManager.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: GoBillManager.Repo

  use GoBillManager.BillFactory
  use GoBillManager.EmployeeFactory
  use GoBillManager.ProductFactory
  use GoBillManager.CustomerFactory
end
