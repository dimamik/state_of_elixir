defmodule StateOfElixirWeb.SurveyControllerTest do
  use StateOfElixirWeb.ConnCase

  describe "GET /survey" do
    test "renders survey page", %{conn: conn} do
      html =
        conn
        |> get(~p"/survey")
        |> html_response(200)

      assert html =~ "State of Elixir"
      assert html =~ "Introduction"
    end

    test "Questions are displaying properly", %{conn: conn} do
      html =
        conn
        |> get(~p"/survey")
        |> html_response(200)

      assert html =~ "What is your age?"
    end
  end
end
