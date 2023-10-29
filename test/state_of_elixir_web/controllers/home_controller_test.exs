defmodule StateOfElixirWeb.HomeControllerTest do
  use StateOfElixirWeb.ConnCase

  describe "GET /" do
    test "renders start page", %{conn: conn} do
      html =
        conn
        |> get(~p"/")
        |> html_response(200)

      assert html =~ "State of Elixir"
    end
  end
end
