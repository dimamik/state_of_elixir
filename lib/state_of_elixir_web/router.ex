defmodule StateOfElixirWeb.Router do
  use StateOfElixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StateOfElixirWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StateOfElixirWeb do
    pipe_through :browser

    get "/", HomeController, :start
  end

  import Phoenix.LiveDashboard.Router

  scope "/admin" do
    pipe_through [:browser, :auth]

    live_dashboard "/dashboard", metrics: StateOfElixirWeb.Telemetry
  end

  defp auth(conn, _opts) do
    %{username: username, password: password} =
      :state_of_elixir
      |> Application.fetch_env!(:basic_auth)
      |> Map.new()

    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
