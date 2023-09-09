defmodule StateOfElixirWeb.HomeHTML do
  use StateOfElixirWeb, :html

  import Phoenix.HTML.Link

  embed_templates("home/*")
end
