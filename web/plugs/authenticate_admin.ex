require IEx
defmodule ElixirJobBoard.Plugs.AuthenticateAdmin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias ElixirJobBoard.Repo
  alias ElixirJobBoard.User

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_user(conn)
    IEx.pry
    if user && User.is_admin?(user) do
      conn |> assign(:current_user, user)
    else
      conn
      |> put_flash(:info, "You must be logged in as an admin.")
      |> redirect(to: "/")
      |> halt
    end
  end

  defp get_user(conn) do
    case conn.assigns[:current_user] do
      nil  -> fetch_user(conn)
      user -> user
    end
  end

  defp fetch_user(conn) do
    find_user(get_session(conn, :current_user))
  end

  defp find_user(nil), do: nil
  defp find_user(id) do
    Repo.get(User, id)
  end
end
