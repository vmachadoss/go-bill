defmodule GoBillManager.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: GoBillManager.Repo

  use GoBillManager.BillFactory
  use GoBillManager.BoardFactory
  use GoBillManager.EmployeeFactory
end
