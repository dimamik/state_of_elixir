defmodule StateOfElixir.Response do
  use Ecto.Schema
  import Ecto.Changeset

  alias StateOfElixir.Repo

  alias __MODULE__.{RequestMetadata, UserResponse}

  schema "responses" do
    embeds_one :request_metadata, RequestMetadata, on_replace: :update
    embeds_one :user_response, UserResponse, on_replace: :update

    timestamps()
  end

  def changeset(response \\ %__MODULE__{}, params \\ %{}) do
    response
    |> cast(params, [])
    |> cast_embed(:request_metadata)
    |> cast_embed(:user_response)
  end

  def upsert(response, params \\ %{}) do
    response
    |> changeset(params)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:id])
  end
end
