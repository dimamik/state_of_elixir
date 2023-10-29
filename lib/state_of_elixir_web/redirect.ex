defmodule StateOfElixirWeb.Redirect do
  @moduledoc false

  def init(opts) do
    if Keyword.has_key?(opts, :to) do
      opts
    else
      raise("Missing required option ':to' in redirect")
    end
  end

  def call(conn, opts) do
    Phoenix.Controller.redirect(conn, opts)
  end
end
