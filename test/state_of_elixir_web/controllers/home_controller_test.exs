defmodule StateOfElixirWeb.HomeControllerTest do
  use StateOfElixirWeb.ConnCase

  describe "GET /" do
    test "renders start page", %{conn: conn} do
      html =
        conn
        |> get(~p"/")
        |> html_response(200)

      assert html =~ "State of Elixir"
      assert html =~ "Take survey"
    end

    test "redirects to thanks page when survey was finished", %{conn: conn} do
      assert "/thanks" =
               conn
               |> put_req_cookie("finished", "true")
               |> get(~p"/")
               |> redirected_to()
    end
  end
end
