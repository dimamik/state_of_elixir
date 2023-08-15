defmodule StateOfElixirWeb.AttendanceVerifier do
  import Phoenix.Controller, only: [redirect: 2]

  alias StateOfElixirWeb.Router.Helpers, as: Routes

  @doc """
  Returns true if the user has finished the survey.
  The cookie "finished" is set by the server when the user submitted the valid answer to the last section (and the whole form).
  """
  def ensure_not_finished(conn) do
    if Map.get(conn.cookies, "finished") == "true" do
      conn
      |> redirect(to: Routes.home_path(conn, :thanks))
      |> Plug.Conn.halt()
    else
      conn
    end
  end

  @doc """
  When the submitted form is considered valid, the server sets the cookie "finished" to "true".
  """
  def mark_as_finished(conn) do
    conn
    # TODO Uncomment this when the testing is done
    # Plug.Conn.put_resp_cookie(conn, "finished", "true")
  end

  @doc """
  Returns true if the user has started the survey.
  The cookie "progress" is set by the client itself when the user submitted the answer to the first section.
  """
  def started_survey?(conn) do
    not is_nil(Map.get(conn.cookies, "progress"))
  end
end
