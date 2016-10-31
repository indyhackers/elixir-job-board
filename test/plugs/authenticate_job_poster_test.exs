defmodule ElixirJobBoard.Plugs.AuthenticateJobPosterTest do
  use ElixirJobBoard.ConnCase

  @session  Plug.Session.init([
    store:            :cookie,
    key:              "_app",
    encryption_salt:  "secret",
    signing_salt:     "secret",
    encrypt:          false
  ])

  test "user is redirected when current_user is not assigned" do
    conn = build_conn()
            |> setup_session
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})

    assert redirected_to(conn) == "/"
  end

  test "user passes through when current_user is assigned" do
    user = ElixirJobBoard.Factory.insert(:user)
    conn = build_conn()
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})

    assert conn.status != 302
  end

  test "user object is made available in the connection when current_user is assigned" do
    user = ElixirJobBoard.Factory.insert(:user)
    conn = build_conn()
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})

    assert conn.assigns[:current_user] == user
  end

  test "user id is set in session the current_user is assigned" do
    user = ElixirJobBoard.Factory.insert(:user)
    conn = build_conn()
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})

    assert get_session(conn, :current_user) == user.id
  end

  defp setup_session(conn) do
    conn
      |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
      |> Plug.Session.call(@session)
      |> fetch_session
      |> fetch_flash
  end
end
