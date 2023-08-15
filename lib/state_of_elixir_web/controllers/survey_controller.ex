defmodule StateOfElixirWeb.SurveyController do
  use StateOfElixirWeb, :controller

  alias StateOfElixirWeb.AttendanceVerifier

  alias Ecto.Changeset

  alias StateOfElixir.Response

  def survey(conn, _params) do
    conn
    |> AttendanceVerifier.ensure_not_finished()
    |> render("survey.html", changeset: Response.changeset(), response: %Response{})
  end

  def submit(conn, %{"update" => params}) do
    case Response.upsert(%Response{}, add_request_metadata(params, conn)) do
      {:ok, _response} ->
        conn
        |> put_flash(:info, "Successfully submitted the survey")
        |> AttendanceVerifier.mark_as_finished()
        |> redirect(to: Routes.home_path(conn, :thanks))

      {:error, %Changeset{} = changeset} ->
        handle_changeset_error(conn, response: changeset.data, changeset: changeset)
    end
  end

  defp add_request_metadata(params, conn) do
    Map.merge(params, %{
      "request_metadata" => %{
        "remote_ip" => to_string(:inet_parse.ntoa(conn.remote_ip))
      }
    })
  end

  defp handle_changeset_error(conn, assigns) do
    conn
    |> put_status(422)
    |> render("survey.html", assigns)
  end
end
