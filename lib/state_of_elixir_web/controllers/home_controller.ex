defmodule StateOfElixirWeb.HomeController do
  use StateOfElixirWeb, :controller

  alias StateOfElixirWeb.AttendanceVerifier

  def start(conn, _params) do
    conn
    |> AttendanceVerifier.ensure_not_finished()
    |> render("start.html", layout: false)
  end

  def thanks(conn, _params) do
    render(conn, "thanks.html", layout: false)
  end
end
