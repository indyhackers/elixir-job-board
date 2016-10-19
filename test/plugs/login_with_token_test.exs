defmodule ElixirJobBoard.Plugs.LoginWithTokenTest do
  use ElixirJobBoard.ConnCase

  import ElixirJobBoard.Factory

  @session  Plug.Session.init([
    store:            :cookie,
    key:              "_app",
    encryption_salt:  "secret",
    signing_salt:     "secret",
    encrypt:          false
  ])

  test "user is not set when no token is present" do
    job = insert(:job)
    conn = build_conn(:get, "/jobs/#{job.id}/edit", %{})
            |> setup_session
            |> ElixirJobBoard.Plugs.LoginWithToken.call(%{})

    assert conn.assigns[:current_user] == nil
  end

  test "user is not set when token doesn't match a user" do
    job = insert(:job)
    token = String.duplicate("abcdefgh", 8)
    conn = build_conn(:get, "/jobs/#{job.id}/edit?token=#{token}", %{})
            |> setup_session
            |> ElixirJobBoard.Plugs.LoginWithToken.call(%{})

    assert conn.assigns[:current_user] == nil
  end

  test "user passes through when token matches a user" do
    job = insert(:job)
    user = insert(:user, token: String.duplicate("abcdefgh", 8))
    conn = build_conn(:get, "/jobs/#{job.id}/edit?token=#{user.token}", %{})
            |> setup_session
            |> ElixirJobBoard.Plugs.LoginWithToken.call(%{})

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
