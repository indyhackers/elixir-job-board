defmodule ElixirJobBoard.Plugs.AuthorizeJobPoster do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias ElixirJobBoard.Repo
  alias ElixirJobBoard.User
  alias ElixirJobBoard.Job

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_user_assigned_this_request(conn)
    job = get_job_from_params(conn)
    if job == nil || user == nil || job.user_id != user.id do
      conn
      |> put_flash(:info, "You are not authorized to edit that job.")
      |> redirect(to: "/")
      |> halt
    else
      conn
    end
  end

  defp get_user_assigned_this_request(conn) do
    conn.assigns[:current_user]
  end

  defp get_job_from_params(conn) do
    conn = fetch_query_params(conn)
    Repo.get(Job, Enum.at(conn.path_info, 1))
  end
end
