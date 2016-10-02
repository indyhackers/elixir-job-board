defmodule ElixirJobBoard.SessionControllerTest do
  use ElixirJobBoard.ConnCase
  import ElixirJobBoard.Factory
  alias ElixirJobBoard.Session
  require IEx

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200)
  end

  test "successfull POST /login", %{conn: conn} do
    user = insert(:user)
    session_params = %{"email" => user.email,
                       "password" => "password"}
    conn = post conn, "/login", %{"session" => session_params}
    assert get_flash(conn, :info) == "Logged in"
    assert redirected_to(conn) =~ "/"
    assert Session.current_user(conn) == user
    assert Session.logged_in?(conn)
  end

  test "unsuccessful POST /login", %{conn: conn} do
    session_params = %{"email" => "notauser@notauser.com",
                       "password" => nil}
    conn = post conn, "/login", %{"session" => session_params}
    assert get_flash(conn, :info) == "Wrong email or password"
    refute Session.logged_in?(conn)
  end

  test "DELETE /logout", %{conn: conn} do
    user = insert(:user)
    conn = delete conn, "/logout"
    assert get_flash(conn, :info) == "Logged out"
    assert redirected_to(conn) =~ "/"
    refute Session.current_user(conn) == user
    refute Session.logged_in?(conn)
  end
end
