defmodule ElixirJobBoard.Session do
  alias ElixirJobBoard.User
  require IEx

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: ElixirJobBoard.Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
