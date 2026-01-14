defmodule StateOfElixirWeb.ResultsLive do
  @moduledoc """
  LiveView for displaying survey results in real-time.
  """
  use StateOfElixirWeb, :live_view

  alias StateOfElixir.Results

  @refresh_interval :timer.seconds(30)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(@refresh_interval, self(), :refresh)
    end

    socket =
      socket
      |> assign(:page_title, "Results")
      |> assign_results()

    {:ok, socket}
  end

  @impl true
  def handle_info(:refresh, socket) do
    {:noreply, assign_results(socket)}
  end

  defp assign_results(socket) do
    socket
    |> assign(:total_responses, Results.total_responses())
    |> assign(:results, Results.all_results())
    |> assign(:last_response_at, Results.last_response_at())
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full max-w-6xl mx-auto">
      <!-- Header -->
      <header class="text-center mb-12 animate-fade-in-up">
        <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-white/10 mb-6">
          <span class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
          <span class="text-sm text-zinc-400">Live Results</span>
        </div>
        <h1 class="mb-4">State of Elixir 2026</h1>
        <p class="text-lg text-zinc-400 max-w-2xl mx-auto">
          Survey Results
        </p>
      </header>
      
    <!-- Stats Overview -->
      <div class="grid gap-6 md:grid-cols-3 mb-12">
        <div
          class="glass-card text-center animate-fade-in-up"
          style="animation-delay: 0.1s; opacity: 0;"
        >
          <div class="text-4xl font-bold text-violet-400 mb-2">{@total_responses}</div>
          <div class="text-zinc-400">Total Responses</div>
        </div>
        <div
          class="glass-card text-center animate-fade-in-up"
          style="animation-delay: 0.2s; opacity: 0;"
        >
          <div class="text-4xl font-bold text-violet-400 mb-2">{length(@results)}</div>
          <div class="text-zinc-400">Questions Analyzed</div>
        </div>
        <div
          class="glass-card text-center animate-fade-in-up"
          style="animation-delay: 0.3s; opacity: 0;"
        >
          <div class="text-4xl font-bold text-violet-400 mb-2">
            {format_time_ago(@last_response_at)}
          </div>
          <div class="text-zinc-400">Latest Response</div>
        </div>
      </div>
      
    <!-- Results Grid -->
      <div class="space-y-8">
        <%= for {{field, data}, index} <- Enum.with_index(@results) do %>
          <.result_card field={field} data={data} index={index} />
        <% end %>
      </div>
      
    <!-- Back Link -->
      <div class="text-center mt-12 animate-fade-in-up">
        <a href={~p"/"} class="btn btn-secondary">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 19l-7-7m0 0l7-7m-7 7h18"
            />
          </svg>
          Back to Home
        </a>
      </div>
    </div>
    """
  end

  defp result_card(assigns) do
    total = Enum.reduce(assigns.data, 0, fn {_value, count}, acc -> acc + count end)
    assigns = assign(assigns, :total, total)
    assigns = assign(assigns, :label, Results.field_label(assigns.field))
    assigns = assign(assigns, :is_text_field, Results.text_field?(assigns.field))

    ~H"""
    <div
      class={"glass-card animate-fade-in-up #{if @is_text_field, do: "overflow-visible", else: ""}"}
      style={"animation-delay: #{0.1 + @index * 0.05}s; opacity: 0;"}
    >
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl">{@label}</h2>
        <span class="text-sm text-zinc-500">{@total} responses</span>
      </div>

      <%= if @total == 0 do %>
        <p class="text-zinc-500 text-sm italic">No responses yet</p>
      <% else %>
        <%= if @is_text_field do %>
          <.text_responses data={@data} />
        <% else %>
          <div class="space-y-3">
            <%= for {value, count} <- @data do %>
              <.bar_item value={value} count={count} total={@total} />
            <% end %>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp text_responses(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-3 pt-2">
      <%= for {value, count} <- @data do %>
        <.text_tag value={value} count={count} />
      <% end %>
    </div>
    """
  end

  @max_tag_length 50

  defp text_tag(assigns) do
    truncated = truncate_text(assigns.value, @max_tag_length)
    assigns = assign(assigns, :display_value, truncated)

    ~H"""
    <span class="relative group/tag" style="z-index: 1;">
      <span class="inline-flex items-center gap-2 px-4 py-2 rounded-lg bg-white/[0.03] border border-white/[0.08] text-sm text-zinc-200 hover:bg-white/[0.06] hover:border-violet-500/30 transition-all duration-300 cursor-default backdrop-blur-sm">
        <span>{@display_value}</span>
        <%= if @count > 1 do %>
          <span class="inline-flex items-center justify-center min-w-[1.25rem] h-5 px-1.5 rounded-full bg-gradient-to-r from-violet-500/20 to-purple-500/20 text-xs text-violet-300 font-medium">
            {@count}
          </span>
        <% end %>
      </span>
      <span
        class="pointer-events-none absolute left-0 bottom-full mb-2 px-4 py-3 bg-[#1f1f2e] border border-white/10 rounded-xl text-sm text-zinc-200 whitespace-pre-wrap max-w-xs opacity-0 invisible group-hover/tag:opacity-100 group-hover/tag:visible transition-all duration-200 shadow-[0_20px_40px_rgba(0,0,0,0.4)]"
        style="z-index: 9999;"
      >
        {@value}
      </span>
    </span>
    """
  end

  defp truncate_text(text, max_length) when byte_size(text) <= max_length, do: text

  defp truncate_text(text, max_length) do
    String.slice(text, 0, max_length - 1) <> "…"
  end

  defp bar_item(assigns) do
    percentage =
      if assigns.total > 0, do: Float.round(assigns.count / assigns.total * 100, 1), else: 0

    assigns = assign(assigns, :percentage, percentage)

    ~H"""
    <div class="group">
      <div class="flex items-center justify-between mb-1">
        <span class="text-sm text-zinc-300 truncate max-w-[60%]" title={@value}>
          {@value}
        </span>
        <span class="text-sm text-zinc-500">
          {@count} ({@percentage}%)
        </span>
      </div>
      <div class="h-2 bg-white/5 rounded-full overflow-hidden">
        <div
          class="h-full bg-gradient-to-r from-violet-500 to-purple-500 rounded-full transition-all duration-500"
          style={"width: #{@percentage}%"}
        >
        </div>
      </div>
    </div>
    """
  end

  defp format_time_ago(nil), do: "N/A"

  defp format_time_ago(naive_datetime) do
    now = NaiveDateTime.utc_now()
    diff_seconds = NaiveDateTime.diff(now, naive_datetime)

    cond do
      diff_seconds < 60 -> "#{diff_seconds}s ago"
      diff_seconds < 3600 -> "#{div(diff_seconds, 60)}m ago"
      diff_seconds < 86_400 -> "#{div(diff_seconds, 3600)}h ago"
      true -> "#{div(diff_seconds, 86400)}d ago"
    end
  end
end
