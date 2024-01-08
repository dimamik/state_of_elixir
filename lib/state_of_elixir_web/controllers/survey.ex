defmodule StateOfElixirWeb.SurveyHTML do
  use StateOfElixirWeb, :html

  import StateOfElixirWeb.SurveyForm
  use PhoenixHTMLHelpers

  embed_templates("survey/*")
end
