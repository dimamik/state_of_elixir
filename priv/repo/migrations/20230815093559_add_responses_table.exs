defmodule StateOfElixir.Repo.Migrations.AddResponsesTable do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :request_metadata, :jsonb, null: false
      add :user_answers, :jsonb, null: false

      timestamps()
    end
  end
end
