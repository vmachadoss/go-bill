defmodule GoBillManager.Repo do
  use Ecto.Repo,
    otp_app: :go_bill_manager,
    adapter: Ecto.Adapters.Postgres
end
