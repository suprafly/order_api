defmodule OrderApi.Repo do
  use Ecto.Repo,
    otp_app: :order_api,
    adapter: Ecto.Adapters.Postgres
end
