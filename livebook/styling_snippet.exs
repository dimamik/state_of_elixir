# State of Elixir 2026 - Livebook App Styling
#
# Add this code cell at the beginning of your Livebook notebook
# to apply custom styling that matches the State of Elixir theme.
#
# This uses Kino.HTML to inject custom CSS into the app.

custom_css = """
<style>
  /* State of Elixir 2026 - Custom Theme */

  :root {
    --accent-purple: #8b5cf6;
    --accent-violet: #a78bfa;
    --surface-dark: #0f0f23;
    --surface-mid: #1a1a2e;
  }

  /* Dark gradient background */
  body, .app-container, [data-el-app] {
    background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 50%, #16213e 100%) !important;
    color: #e4e4e7 !important;
    min-height: 100vh;
  }

  /* Subtle background effect */
  body::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background:
      radial-gradient(circle at 20% 80%, rgba(139, 92, 246, 0.08) 0%, transparent 50%),
      radial-gradient(circle at 80% 20%, rgba(167, 139, 250, 0.06) 0%, transparent 50%);
    pointer-events: none;
    z-index: -1;
  }

  /* Typography */
  h1, h2, h3, h4, h5, h6 {
    color: #f4f4f5 !important;
    font-weight: 600;
  }

  h1 {
    background: linear-gradient(135deg, #ffffff 0%, #a78bfa 50%, #8b5cf6 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  p, span, li {
    color: #a1a1aa !important;
  }

  /* Glass card effect for containers */
  .card, [data-el-cell], .output-wrapper, .kino-layout {
    background: rgba(255, 255, 255, 0.03) !important;
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 1rem !important;
    padding: 1.5rem !important;
    margin-bottom: 1rem;
  }

  /* Buttons */
  button, .btn, [type="submit"] {
    background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%) !important;
    color: white !important;
    border: none !important;
    border-radius: 0.75rem !important;
    padding: 0.75rem 1.5rem !important;
    font-weight: 500 !important;
    box-shadow: 0 4px 15px rgba(139, 92, 246, 0.3) !important;
    transition: all 0.3s ease !important;
    cursor: pointer;
  }

  button:hover, .btn:hover, [type="submit"]:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4) !important;
  }

  /* Form inputs */
  input, select, textarea {
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.1) !important;
    border-radius: 0.5rem !important;
    color: #e4e4e7 !important;
    padding: 0.75rem 1rem !important;
  }

  input:focus, select:focus, textarea:focus {
    outline: none !important;
    border-color: #8b5cf6 !important;
    box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.15) !important;
  }

  input::placeholder, textarea::placeholder {
    color: #71717a !important;
  }

  /* Links */
  a {
    color: #a78bfa !important;
    text-decoration: none !important;
    transition: color 0.2s ease !important;
  }

  a:hover {
    color: #c4b5fd !important;
  }

  /* Tables */
  table {
    width: 100%;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    border-radius: 0.75rem !important;
    overflow: hidden !important;
    background: rgba(255, 255, 255, 0.02) !important;
  }

  th {
    background: rgba(139, 92, 246, 0.2) !important;
    color: #e4e4e7 !important;
    font-weight: 600 !important;
    padding: 1rem !important;
    text-align: left !important;
  }

  td {
    padding: 0.875rem 1rem !important;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
    color: #a1a1aa !important;
  }

  tr:hover td {
    background: rgba(139, 92, 246, 0.1) !important;
  }

  /* Code blocks */
  pre, code {
    background: rgba(0, 0, 0, 0.3) !important;
    border-radius: 0.5rem !important;
    color: #e4e4e7 !important;
  }

  /* Charts and visualizations */
  .vega-embed, [data-el-vega-lite-container] {
    background: transparent !important;
    border-radius: 0.75rem;
    padding: 1rem;
  }

  /* Kino data table */
  .kino-data-table {
    border-radius: 0.75rem !important;
    overflow: hidden !important;
  }

  /* Select dropdowns */
  .kino-input-select select {
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23a1a1aa'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 0.75rem center;
    background-size: 1rem;
    padding-right: 2.5rem !important;
  }

  /* Scrollbars */
  ::-webkit-scrollbar {
    width: 8px;
    height: 8px;
  }

  ::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 4px;
  }

  ::-webkit-scrollbar-thumb {
    background: rgba(139, 92, 246, 0.3);
    border-radius: 4px;
  }

  ::-webkit-scrollbar-thumb:hover {
    background: rgba(139, 92, 246, 0.5);
  }

  /* Animation */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .animate-fade-in {
    animation: fadeInUp 0.6s ease-out forwards;
  }

  /* Selection */
  ::selection {
    background: rgba(139, 92, 246, 0.3);
    color: #fff;
  }

  /* Badge/Tag styles */
  .badge, .tag {
    display: inline-flex;
    align-items: center;
    padding: 0.25rem 0.75rem;
    border-radius: 9999px;
    background: rgba(139, 92, 246, 0.2);
    color: #a78bfa;
    font-size: 0.875rem;
    font-weight: 500;
  }

  /* Divider */
  hr {
    border: none;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(167, 139, 250, 0.3), transparent);
    margin: 2rem 0;
  }

  /* Stats/metric cards */
  .stat-card {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 0.75rem;
    padding: 1.5rem;
    text-align: center;
  }

  .stat-value {
    font-size: 2.5rem;
    font-weight: 700;
    background: linear-gradient(135deg, #ffffff 0%, #a78bfa 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .stat-label {
    color: #71717a;
    font-size: 0.875rem;
    margin-top: 0.5rem;
  }
</style>
"""

Kino.HTML.new(custom_css)
