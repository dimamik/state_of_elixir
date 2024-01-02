defmodule StateOfElixir.Response.UserAnswers do
  @moduledoc """
  Represents the answers that the user provided to the survey form.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StateOfElixir.Countries
  alias StateOfElixir.Languages

  @exp_years [
    "<= 1",
    "1-2 years",
    "2-3 years",
    "4-5 years",
    "6 or more years"
  ]

  @yes_or_no [
    "Yes",
    "No"
  ]

  @survey_options %{
    company_size: [
      "1",
      "2-5",
      "6-10",
      "11-20",
      "21-50",
      "51-100",
      "101-500",
      "501-1000",
      "1000+"
    ],
    higher_education_degree: [
      "No",
      "Related",
      "Unrelated"
    ],
    elixir_exp_years: @exp_years,
    overall_exp_years: @exp_years,
    gender: [
      "Female",
      "Male",
      "NL",
      "Non-binary",
      "Other"
    ],
    yearly_salary_in_usd: [
      "free",
      "0-10k",
      "10-30k",
      "30-50k",
      "50-100k",
      "100-200k",
      "200+k"
    ],
    contribution_to_open_source: @yes_or_no,
    contribution_to_elixir: @yes_or_no,
    industry_sector: [
      "Cyber Security",
      "Manufacturing",
      "Construction",
      "Insurance",
      "Agriculture",
      "Government",
      "Telecommunications",
      "Hospitality",
      "Automotive",
      "Student",
      "Transport",
      "Real Estate",
      "Marketing/Sales/Analytics Tools",
      "Logistics",
      "Travel",
      "Consulting & Services",
      "Crypto & Web3",
      "Programming & Technical Tools",
      "News, Media, & Blogging",
      "Education",
      "Social Media",
      "Entertainment",
      "Finance",
      "Healthcare",
      "Ecommerce & Retai",
      "Other"
    ],
    team_size: [
      "Solo developer",
      "2",
      "3-5",
      "6-10",
      "more than 10"
    ],
    how_do_you_use_elixir: [
      "Professionaly",
      "As a student",
      "As a hobby"
    ],
    top_elixir_app_user_count: [
      "2-100",
      "101-1k",
      "1k-10k",
      "10k-100k",
      "100k-1M",
      "1M and more"
    ]
  }

  @primary_key false
  # TODO Add more sections
  embedded_schema do
    # First section - About you
    field :age, :integer
    field :company_size, :string
    field :country, :string
    field :higher_education_degree, :string
    field :elixir_exp_years, :string
    field :overall_exp_years, :string
    field :gender, :string
    field :locale, :string
    field :yearly_salary_in_usd, :string

    # Second section - Developer background
    field :before_elixir, :string
    field :contribution_to_open_source, :string
    field :contribution_to_elixir, :string
    field :industry_sector, :string
    field :team_size, :string
    field :how_do_you_use_elixir, :string
    field :top_elixir_app_user_count, :string

    field :survey_feedback, :string
  end

  @optional_fields ~w(
    before_elixir
    company_size
    gender
    survey_feedback
    top_elixir_app_user_count
    yearly_salary_in_usd
  )a

  def changeset(user_answers, params) do
    user_answers
    |> cast(params, __schema__(:fields))
    |> validate_required(__schema__(:fields) -- @optional_fields)
    |> validate_inclusions()
    # validate_number/4 returns an error without text interpolation
    # >> "must be less than %{number}"
    # But we can rely on frontend validation
    |> validate_number(:age, greater_than: 15, less_than: 100)
  end

  def survey_options(:country) do
    Countries.countries_with_flags()
  end

  def survey_options(:locale) do
    Languages.languages()
  end

  def survey_options(field) when is_map_key(@survey_options, field) do
    Map.fetch!(@survey_options, field)
  end

  def required?(field) when is_atom(field) do
    field not in @optional_fields
  end

  defp validate_inclusions(changeset) do
    Enum.reduce(@survey_options, changeset, fn {field, values}, acc_changeset ->
      validate_inclusion(acc_changeset, field, values, message: "Can't be blank")
    end)
  end
end
