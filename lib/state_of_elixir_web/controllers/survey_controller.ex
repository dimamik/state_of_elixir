defmodule StateOfElixirWeb.SurveyController do
  use StateOfElixirWeb, :controller

  alias StateOfElixirWeb.AttendanceVerifier
  alias StateOfElixir.Response.UserResponse

  alias Ecto.Changeset

  alias StateOfElixir.Response

  def survey(conn, _params) do
    conn
    |> AttendanceVerifier.ensure_not_finished()
    |> render("survey.html", changeset: Response.changeset(), user_response: %UserResponse{})
  end

  def submit(conn, %{"update" => params}) do
    case Response.upsert(%Response{}, add_request_metadata(params, conn)) do
      {:ok, _response} ->
        conn
        |> put_flash(:info, "Successfully submitted the survey")
        |> AttendanceVerifier.mark_as_finished()
        |> redirect(to: Routes.home_path(conn, :thanks))

      {:error, %Changeset{} = changeset} ->
        handle_changeset_error(conn,
          changeset: changeset,
          # user_response: changeset.changes.user_response.changes
          user_response: get_user_response(changeset)
        )
    end
  end

  defp get_user_response(%Changeset{} = response_changeset) do
    response_changeset.changes.user_response.changes
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
