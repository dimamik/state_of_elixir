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
    get "/thanks", HomeController, :thanks

    get "/survey", SurveyController, :survey
    post "/survey", SurveyController, :submit
  end

  # Other scopes may use custom stacks.
  # scope "/api", StateOfElixirWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:state_of_elixir, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StateOfElixirWeb.Telemetry
    end
  end
end
