defmodule PodiumApi.Repo do
  use Ecto.Repo,
    otp_app: :podium_api,
    adapter: Ecto.Adapters.Postgres
end
