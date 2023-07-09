defmodule StateOfElixirWeb.ErrorJSONTest do
  use StateOfElixirWeb.ConnCase, async: true

  test "renders 404" do
    assert StateOfElixirWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert StateOfElixirWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
