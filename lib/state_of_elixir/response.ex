defmodule StateOfElixir.Response do
  @moduledoc """
  Submitted form entry. Contains user's answers and metadata about the request.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias StateOfElixir.Repo

  alias __MODULE__.{RequestMetadata, UserAnswers}

  schema "responses" do
    embeds_one :request_metadata, RequestMetadata, on_replace: :update
    embeds_one :user_answers, UserAnswers, on_replace: :update

    timestamps()
  end

  def changeset(response \\ %__MODULE__{}, params \\ %{}) do
    response
    |> cast(params, [])
    |> cast_embed(:request_metadata)
    |> cast_embed(:user_answers)
  end

  def upsert(response, params \\ %{}) do
    response
    |> changeset(params)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:id])
  end
end
