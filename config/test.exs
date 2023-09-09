import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :state_of_elixir, StateOfElixir.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "state_of_elixir_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :state_of_elixir, StateOfElixirWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+RMuIw5arJK+a/qrif0ufLzG5+KbIZKcg9XtsXUbv0w10ZhBPk64EptzP99yWS6q",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
