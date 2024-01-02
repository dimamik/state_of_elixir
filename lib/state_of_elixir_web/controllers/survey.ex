defmodule StateOfElixirWeb.SurveyHTML do
  use StateOfElixirWeb, :html

  import StateOfElixirWeb.SurveyForm
  import Phoenix.HTML.Form

  embed_templates("survey/*")
end
