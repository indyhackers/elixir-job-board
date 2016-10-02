defmodule ElixirJobBoard.Plugs.AuthenticateAdminTest do
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
            |> ElixirJobBoard.Plugs.AuthenticateAdmin.call(%{})

    assert redirected_to(conn) == "/"
  end

  test "user is redirected when current_user is assigned but isn't an admin" do
    user = ElixirJobBoard.Factory.insert(:user, %{ admin: false })
    conn = build_conn()
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateAdmin.call(%{})

    assert redirected_to(conn) == "/"
  end

  test "user passes through when current_user is assigned and is an admin" do
    user = ElixirJobBoard.Factory.insert(:user, %{ admin: true })
    conn = build_conn()
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateAdmin.call(%{})

    assert conn.status != 302
  end

  defp setup_session(conn) do
    conn
      |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
      |> Plug.Session.call(@session)
      |> fetch_session
      |> fetch_flash
  end
end
