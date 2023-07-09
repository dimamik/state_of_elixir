defmodule StateOfElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StateOfElixirWeb.Telemetry,
      # Start the Ecto repository
      StateOfElixir.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: StateOfElixir.PubSub},
      # Start Finch
      {Finch, name: StateOfElixir.Finch},
      # Start the Endpoint (http/https)
      StateOfElixirWeb.Endpoint
      # Start a worker by calling: StateOfElixir.Worker.start_link(arg)
      # {StateOfElixir.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StateOfElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StateOfElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
