defmodule StateOfElixirWeb.SurveyForm do
  @moduledoc """
  Components used in survey form.
  """
  use StateOfElixirWeb, :html
  use PhoenixHTMLHelpers

  alias StateOfElixir.Response.UserAnswers

  def stepper(assigns) do
    ~H"""
    <ul class="list-none space-y-2">
      {render_slot(@inner_block)}
    </ul>
    """
  end

  def stepper_item(assigns) do
    stepper_class =
      if Map.get(assigns, :last) do
        "relative"
      else
        "relative after:absolute after:left-[1.75rem] after:top-[4rem] after:h-[calc(100%-3rem)] after:w-[2px] after:bg-gradient-to-b after:from-violet-500/40 after:to-violet-500/10 after:content-['']"
      end

    assigns = assign(assigns, :stepper_class, stepper_class)

    ~H"""
    <li data-te-stepper-step-ref class={@stepper_class}>
      <div
        data-te-stepper-head-ref
        class="flex items-center gap-4 p-4 rounded-xl transition-colors"
      >
        <span
          data-te-stepper-head-icon-ref
          class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-violet-500 to-purple-600 text-sm font-semibold text-white shadow-lg shadow-violet-500/25"
        >
          {@index}
        </span>
        <span
          data-te-stepper-head-text-ref
          class="text-xl font-semibold text-zinc-100"
        >
          {@name}
        </span>
      </div>
      <div
        data-te-stepper-content-ref
        class="pl-[3.5rem] pr-4 pb-6 space-y-6"
      >
        {render_slot(@inner_block)}
      </div>
    </li>
    """
  end

  def form_question(%{field: field} = assigns) do
    required_class = if UserAnswers.required?(field), do: "required"
    search = if Map.get(assigns, :search), do: "true", else: "false"
    selected = Map.get(assigns.user_answers, field)

    assigns =
      assigns
      |> assign(:search, search)
      |> assign(:required_class, required_class)
      |> assign(:selected, selected)

    ~H"""
    {case assigns.type do
      :number ->
        custom_number_input(assigns)

      :pick_one ->
        custom_pick_one(assigns)

      :pick_many ->
        custom_pick_many(assigns)

      :text ->
        custom_text(assigns)
    end}
    """
  end

  def custom_number_input(assigns) do
    ~H"""
    <div class="space-y-2">
      <label class={"text-sm font-medium text-zinc-300 #{@required_class}"}>{@label}</label>
      <div class="relative" data-te-input-wrapper-init>
        {number_input(@form, @field,
          class:
            "w-full px-4 py-3 rounded-lg bg-white/5 border border-white/10 text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-violet-500 focus:ring-2 focus:ring-violet-500/20 transition-all",
          min: @min,
          max: @max,
          placeholder: @placeholder,
          value: @selected
        )}
      </div>
      {error_tag(@form, @field)}
    </div>
    """
  end

  def custom_pick_one(%{field: field} = assigns) do
    assigns = assign(assigns, :options, UserAnswers.survey_options(field))

    ~H"""
    <div class="space-y-2">
      <label class={"text-sm font-medium text-zinc-300 #{@required_class}"}>{@label}</label>
      <%= if @selected do %>
        {select(@form, @field, @options,
          "data-te-select-init": "",
          selected: @selected,
          "data-te-select-filter": @search,
          class: "w-full"
        )}
      <% else %>
        {select(@form, @field, @options,
          "data-te-select-init": "",
          "data-te-select-placeholder": "Select an option",
          "data-te-select-filter": @search,
          class: "w-full"
        )}
      <% end %>
      {error_tag(@form, @field)}
    </div>
    """
  end

  def custom_pick_many(assigns) do
    required_class = if UserAnswers.required?(assigns.field), do: "required"

    assigns =
      assigns
      |> assign(:options, UserAnswers.survey_options(assigns.field))
      |> assign(:required_class, required_class)

    ~H"""
    <div class="space-y-2">
      <label data-te-select-label-ref class={"text-sm font-medium text-zinc-300 #{@required_class}"}>
        {@label}
      </label>
      {select(@form, @field, @options,
        "data-te-select-init multiple": "",
        selected: "",
        "data-te-select-placeholder": "Select options",
        class: "w-full"
      )}
      {error_tag(@form, @field)}
    </div>
    """
  end

  def custom_text(assigns) do
    required_class = if UserAnswers.required?(assigns.field), do: "required"

    assigns =
      assigns
      |> assign(:required_class, required_class)
      |> assign_new(:label, fn -> nil end)

    ~H"""
    <div class="space-y-2">
      <%= if @label do %>
        <label class={"text-sm font-medium text-zinc-300 #{@required_class}"}>{@label}</label>
      <% end %>
      <div class="relative" data-te-input-wrapper-init>
        <textarea
          class="w-full px-4 py-3 rounded-lg bg-white/5 border border-white/10 text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-violet-500 focus:ring-2 focus:ring-violet-500/20 transition-all resize-none"
          rows="4"
          placeholder={@placeholder}
        ></textarea>
        {error_tag(@form, @field)}
      </div>
    </div>
    """
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, extract_message(error),
        class: "text-pink-400 text-sm mt-1 block",
        phx_feedback_for: Phoenix.HTML.Form.input_name(form, field)
      )
    end)
  end

  defp extract_message({msg, _} = _error), do: msg
end
