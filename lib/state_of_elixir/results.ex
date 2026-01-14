defmodule StateOfElixir.Results do
  @moduledoc """
  Context module for aggregating and retrieving survey results.
  """

  alias StateOfElixir.Repo
  alias StateOfElixir.Response
  alias StateOfElixir.Response.UserAnswers

  # Fields to exclude from results (free-form text fields not suitable for aggregation)
  @excluded_fields [:survey_feedback]

  # Free-text fields that should be displayed differently (not as bar charts)
  @text_fields [:before_elixir]

  @doc """
  Returns whether a field is a free-text field that needs special display.
  """
  def text_field?(field) when is_atom(field) do
    field in @text_fields
  end

  @doc """
  Returns the total count of survey responses.
  """
  def total_responses do
    Repo.aggregate(Response, :count)
  end

  @doc """
  Returns the timestamp of the most recent response.
  """
  def last_response_at do
    query = "SELECT MAX(inserted_at) FROM responses"

    case Repo.query(query, []) do
      {:ok, %{rows: [[nil]]}} -> nil
      {:ok, %{rows: [[timestamp]]}} -> timestamp
      {:error, _} -> nil
    end
  end

  @doc """
  Returns aggregated counts for a given survey field.
  Results are returned as a list of {value, count} tuples sorted by count descending.
  """
  def aggregate_field(field) when is_atom(field) do
    field_string = Atom.to_string(field)

    query = """
    SELECT user_answers->>$1 as value, COUNT(*) as count
    FROM responses
    WHERE user_answers->>$1 IS NOT NULL
      AND user_answers->>$1 != ''
    GROUP BY user_answers->>$1
    ORDER BY count DESC
    """

    case Repo.query(query, [field_string]) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, fn [value, count] -> {value, count} end)

      {:error, _} ->
        []
    end
  end

  @doc """
  Returns aggregated counts for multiple fields at once.
  Returns a list of {field, [{value, count}, ...]} tuples preserving order.
  """
  def aggregate_fields(fields) when is_list(fields) do
    Enum.map(fields, fn field -> {field, aggregate_field(field)} end)
  end

  @doc """
  Returns all aggregated results for display.
  Fields are automatically pulled from UserAnswers schema in definition order,
  excluding fields listed in @excluded_fields.
  """
  def all_results do
    fields =
      UserAnswers.__schema__(:fields)
      |> Enum.reject(&(&1 in @excluded_fields))

    aggregate_fields(fields)
  end

  @doc """
  Returns field display names for the UI.
  """
  def field_label(field) do
    labels = %{
      age: "Age",
      country: "Country",
      locale: "Native Language",
      gender: "Gender",
      higher_education_degree: "Higher Education",
      elixir_exp_years: "Elixir Experience",
      overall_exp_years: "Overall Experience",
      company_size: "Company Size",
      yearly_salary_in_usd: "Yearly Salary (USD)",
      before_elixir: "Language Before Elixir",
      contribution_to_open_source: "Open Source Contributor",
      contribution_to_elixir: "Elixir Contributor",
      industry_sector: "Industry Sector",
      team_size: "Team Size",
      how_do_you_use_elixir: "How You Use Elixir",
      top_elixir_app_user_count: "Top App User Count"
    }

    Map.get(labels, field, Phoenix.Naming.humanize(field))
  end

  @doc """
  Returns the ordered options for a field (for consistent chart ordering).
  """
  def field_options(field) do
    UserAnswers.survey_options(field)
  rescue
    _ -> nil
  end
end
