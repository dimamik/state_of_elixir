defmodule StateOfElixirWeb.SurveyForm do
  use StateOfElixirWeb, :html

  import Phoenix.HTML.Form
  import Phoenix.HTML.Tag

  alias StateOfElixir.Countries
  alias StateOfElixir.Languages
  alias StateOfElixir.Response.UserResponse

  def stepper(assigns) do
    ~H"""
    <ul>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  def stepper_item(assigns) do
    stepper_class =
      if Map.get(assigns, :last) do
        "relative h-fit"
      else
        "relative h-fit after:absolute after:left-[2.45rem] after:top-[3.6rem] after:mt-px after:h-[calc(100%-2.45rem)] after:w-px after:bg-[#e0e0e0] after:content-[''] dark:after:bg-neutral-600"
      end

    assigns = assign(assigns, :stepper_class, stepper_class)

    ~H"""
    <li data-te-stepper-step-ref class={@stepper_class}>
      <div
        data-te-stepper-head-ref
        class="flex items-center p-6 leading-[1.3rem] no-underline after:bg-[#e0e0e0] after:content-[''] focus:outline-none dark:after:bg-neutral-600 dark:hover:bg-[#3b3b3b]"
      >
        <span
          data-te-stepper-head-icon-ref
          class="mr-3 flex h-[1.938rem] w-[1.938rem] items-center justify-center rounded-full bg-[#ebedef] text-sm font-medium text-[#40464f]"
        >
          <%= @index %>
        </span>
        <span
          data-te-stepper-head-text-ref
          class="text-neutral-500 after:absolute after:flex after:text-[0.8rem] after:content-[data-content] dark:text-neutral-300"
        >
          <%= @name %>
        </span>
      </div>
      <div
        data-te-stepper-content-ref
        class="transition-[height, margin-bottom, padding-top, padding-bottom] left-0 pb-6 pl-[3.75rem] pr-6 duration-300 ease-in-out"
      >
        <%= render_slot(@inner_block) %>
      </div>
    </li>
    """
  end

  def form_question(assigns) do
    ~H"""
    <%= case assigns.type do
      :number ->
        custom_number_input(assigns)

      :pick_one ->
        custom_pick_one(assigns)

      :pick_one_with_icons ->
        custom_pick_one_with_icons(assigns)

      :pick_many ->
        custom_pick_many(assigns)

      :text ->
        custom_text(assigns)
    end %>
    """
  end

  def custom_number_input(assigns) do
    required_class = if UserResponse.required?(assigns.field), do: "required"

    assigns = assign(assigns, :required_class, required_class)

    ~H"""
    <div>
      <label class={@required_class}><%= @label %></label>
      <div class="relative" data-te-input-wrapper-init>
        <%= number_input(assigns.form, assigns.field,
          class:
            "peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 peer-focus:text-primary data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 dark:peer-focus:text-primary [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0",
          min: @min,
          max: @max
        ) %>

        <label
          for="exampleFormControlInputNumber"
          class="pointer-events-none absolute left-3 top-0 mb-0 max-w-[90%] origin-[0_0] truncate pt-[0.37rem] leading-[1.6] text-neutral-500 transition-all duration-200 ease-out peer-focus:-translate-y-[0.9rem] peer-focus:scale-[0.8] peer-focus:text-primary peer-data-[te-input-state-active]:-translate-y-[0.9rem] peer-data-[te-input-state-active]:scale-[0.8] motion-reduce:transition-none dark:text-neutral-200 dark:peer-focus:text-primary"
        >
          <%= @placeholder %>
        </label>
      </div>
      <%= error_tag(@form, @field) %>
    </div>
    """
  end

  def custom_pick_one(assigns) do
    required_class = if UserResponse.required?(assigns.field), do: "required"
    search = if Map.get(assigns, :search), do: "true", else: "false"

    assigns =
      assigns
      |> assign(:options, options(assigns))
      |> assign(:search, search)
      |> assign(:required_class, required_class)

    ~H"""
    <div class="mt-5">
      <label class={@required_class}><%= @label %></label>

      <%= select(@form, @field, @options,
        "data-te-select-init": "",
        "data-te-select-placeholder": "Choose an option",
        "data-te-select-filter": @search
      ) %>
      <%= error_tag(@form, @field) %>
    </div>
    """
  end

  # TODO We could use that to represent country flags, but it uses links
  def custom_pick_one_with_icons(assigns) do
    required_class = if UserResponse.required?(assigns.field), do: "required"

    search = if Map.get(assigns, :search), do: "true", else: "false"

    assigns =
      assigns
      |> assign(:options, options(assigns))
      |> assign(:search, search)
      |> assign(:required_class, required_class)

    ~H"""
    <div class="mt-5">
      <label class={@required_class}><%= @label %></label>

      <%= select(@form, @field, @options,
        "data-te-select-init": "",
        "data-te-select-placeholder": "Choose an option",
        "data-te-select-filter": @search
      ) %>

      <select data-te-select-init>
        <%= for {name, icon} <- @options do %>
          <option value={name} data-te-select-icon={icon}>
            <%= name %>
          </option>
        <% end %>
      </select>

      <%= error_tag(@form, @field) %>
    </div>
    """
  end

  def custom_pick_many(assigns) do
    required_class = if UserResponse.required?(assigns.field), do: "required"

    assigns =
      assigns
      |> assign(:options, options(assigns))
      |> assign(:required_class, required_class)

    ~H"""
    <label data-te-select-label-ref class={@required_class}><%= @label %></label>

    <%= select(@form, @field, @options,
      "data-te-select-init multiple": "",
      selected: "",
      "data-te-select-placeholder": "Choose an option"
    ) %>
    <%= error_tag(@form, @field) %>
    """
  end

  def options(%{field: :country}) do
    Countries.countries_with_flags()
  end

  def options(%{field: :locale}) do
    Languages.languages()
  end

  def options(assigns) do
    Map.fetch!(UserResponse.survey_options(), assigns.field)
  end

  def custom_text(assigns) do
    required_class = if UserResponse.required?(assigns.field), do: "required"

    assigns = assign(assigns, :required_class, required_class)

    ~H"""
    <label class={@required_class}><%= @label %></label>

    <div class="relative mb-3" data-te-input-wrapper-init>
      <textarea
        class="peer block min-h-[auto] w-full rounded border-0 bg-transparent px-3 py-[0.32rem] leading-[1.6] outline-none transition-all duration-200 ease-linear focus:placeholder:opacity-100 data-[te-input-state-active]:placeholder:opacity-100 motion-reduce:transition-none dark:text-neutral-200 dark:placeholder:text-neutral-200 [&:not([data-te-input-placeholder-active])]:placeholder:opacity-0"
        id="exampleFormControlTextarea1"
        rows="3"
        placeholder={@placeholder}
      >
      </textarea>
      <label
        for="exampleFormControlTextarea1"
        class="pointer-events-none absolute left-3 top-0 mb-0 max-w-[90%] origin-[0_0] truncate pt-[0.37rem] leading-[1.6] text-neutral-500 transition-all duration-200 ease-out peer-focus:-translate-y-[0.9rem] peer-focus:scale-[0.8] peer-focus:text-primary peer-data-[te-input-state-active]:-translate-y-[0.9rem] peer-data-[te-input-state-active]:scale-[0.8] motion-reduce:transition-none dark:text-neutral-200 dark:peer-focus:text-primary"
      >
        <%= @placeholder %>
      </label>
      <%= error_tag(@form, @field) %>
    </div>
    """
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, extract_message(error),
        class: "text-red-700",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  defp extract_message({msg, _} = _error), do: msg
end
