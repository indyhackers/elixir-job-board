defmodule ElixirJobBoard.Plugs.AuthenticateJobPoster do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias ElixirJobBoard.Repo
  alias ElixirJobBoard.User

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_user(conn)
    if user do
      conn |> assign(:current_user, user)
    else
      conn
      |> put_flash(:info, "You must be logged in. Please find the link in your email to login and edit your job post.")
      |> redirect(to: "/")
      |> halt
    end
  end

  defp get_user(conn) do
    case user_assigned_this_request(conn) do
      nil  -> fetch_user(conn)
      user -> user
    end
  end

  defp user_assigned_this_request(conn) do
    conn.assigns[:current_user]
  end

  defp fetch_user(conn) do
    find_user(get_session(conn, :current_user))
  end

  defp find_user(nil), do: nil
  defp find_user(id) do
    Repo.get(User, id)
  end
end
