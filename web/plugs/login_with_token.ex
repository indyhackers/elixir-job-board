defmodule ElixirJobBoard.Plugs.LoginWithToken do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias ElixirJobBoard.Repo
  alias ElixirJobBoard.User

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_user_from_token(conn)
    if user do
      conn
      |> assign(:current_user, user)
      |> put_session(:current_user, user.id)
    end
    conn
  end

  defp get_user_from_token(conn) do
    conn = conn |> fetch_query_params()
    find_user_by_token(conn.query_params["token"])
  end

  defp find_user_by_token(nil), do: nil
  defp find_user_by_token(token) do
    Repo.get_by(User, token: token)
  end
end
