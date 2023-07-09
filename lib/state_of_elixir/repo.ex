defmodule StateOfElixir.Repo do
  use Ecto.Repo,
    otp_app: :state_of_elixir,
    adapter: Ecto.Adapters.Postgres
end
