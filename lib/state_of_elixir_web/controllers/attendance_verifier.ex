defmodule StateOfElixirWeb.AttendanceVerifier do
  use Phoenix.VerifiedRoutes, endpoint: StateOfElixirWeb.Endpoint, router: StateOfElixirWeb.Router

  import Phoenix.Controller, only: [redirect: 2, render: 3]

  alias Plug.Conn

  @attendance_verifier_enabled Application.compile_env!(:state_of_elixir, [__MODULE__, :enabled])

  @doc """
  Returns true if the user has finished the survey.
  The cookie "finished" is set by the server when the user submitted the valid answer to the last section (and the whole form).
  """
  def render_if_not_finished(conn, template, assigns \\ []) do
    if finished?(conn) do
      conn
      |> redirect(to: ~p"/thanks")
      |> Conn.halt()
    else
      render(conn, template, assigns)
    end
  end

  @doc """
  Returns true if the user has finished the survey.
  """
  def finished?(conn) do
    @attendance_verifier_enabled and Map.get(conn.cookies, "finished") == "true"
  end

  @doc """
  When the submitted form is considered valid, the server sets the cookie "finished" to "true".
  """
  def mark_as_finished(conn) do
    if @attendance_verifier_enabled do
      Conn.put_resp_cookie(conn, "finished", "true")
    else
      conn
    end
  end

  @doc """
  Returns true if the user has started the survey.
  The cookie "progress" is set by the client itself when the user submitted the answer to the first section.
  """
  def started_survey?(conn) do
    if @attendance_verifier_enabled do
      not is_nil(Map.get(conn.cookies, "progress"))
    else
      false
    end
  end
end
