defmodule StateOfElixirWeb.HomeController do
  use StateOfElixirWeb, :controller

  def start(conn, _params) do
    render(conn, "start.html")
  end

  def thanks(conn, _params) do
    render(conn, "thanks.html")
  end
end
