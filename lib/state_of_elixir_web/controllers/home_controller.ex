defmodule StateOfElixirWeb.HomeController do
  use StateOfElixirWeb, :controller

  alias StateOfElixirWeb.AttendanceVerifier

  def start(conn, _params) do
    AttendanceVerifier.render_if_not_finished(conn, "start.html")
  end

  # TODO Maybe this needs to be the same page as start?
  # Will the content differ that much?
  def thanks(conn, _params) do
    render(conn, "thanks.html")
  end
end
