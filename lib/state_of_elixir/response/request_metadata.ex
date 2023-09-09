defmodule StateOfElixir.Response.RequestMetadata do
  @moduledoc """
  Represents metadata which is attached to each response to the survey form.
  It is controversial whether we can store user's IP or not, but we've opted to do that for now
  for now to filter out similar/suspicious responses later on.
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
