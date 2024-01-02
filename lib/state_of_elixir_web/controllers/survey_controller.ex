defmodule StateOfElixirWeb.SurveyController do
  use StateOfElixirWeb, :controller

  alias StateOfElixirWeb.AttendanceVerifier
  alias StateOfElixir.Response.UserAnswers

  alias Ecto.Changeset

  alias StateOfElixir.Response

  def survey(conn, _params) do
    AttendanceVerifier.render_if_not_finished(conn, "survey.html",
      changeset: Response.changeset(),
      user_answers: %UserAnswers{}
    )
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
          user_answers: get_user_answers(changeset)
        )
    end
  end

  defp get_user_answers(%Changeset{} = response_changeset) do
    response_changeset.changes.user_answers.changes
  end

  defp add_request_metadata(params, conn) do
    Map.merge(params, %{
      "request_metadata" => %{
        # TODO Maybe add more events to log?
        # Is this remote IP correct?
        "remote_ip" => remote_ip(conn)
      }
    })
  end

  defp remote_ip(%{remote_ip: ip}) do
    ip
    |> :inet_parse.ntoa()
    |> to_string()
  end

  defp handle_changeset_error(conn, assigns) do
    conn
    |> put_status(422)
    |> render("survey.html", assigns)
  end
end
