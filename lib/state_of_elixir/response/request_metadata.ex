defmodule StateOfElixir.Response.RequestMetadata do
  @moduledoc """
  This embed would attach the request metadata to each response to prevent spoofing the form
  later on.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          remote_ip: String.t()
        }

  @primary_key false

  embedded_schema do
    field :remote_ip, :string
  end

  def changeset(request_metadata, params) do
    request_metadata
    |> cast(params, __schema__(:fields))
    |> validate_required(__schema__(:fields))
  end
end
