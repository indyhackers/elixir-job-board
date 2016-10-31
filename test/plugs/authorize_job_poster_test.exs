defmodule ElixirJobBoard.Plugs.AuthorizeJobPosterTest do
  use ElixirJobBoard.ConnCase

  import ElixirJobBoard.Factory

  @session  Plug.Session.init([
    store:            :cookie,
    key:              "_app",
    encryption_salt:  "secret",
    signing_salt:     "secret",
    encrypt:          false
  ])

  test "user is authorized when they posted the job" do
    user = insert(:user)
    job = insert(:job, user_id: user.id)
    conn = build_conn(:get, "/jobs/#{job.id}/edit", %{})
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})
            |> ElixirJobBoard.Plugs.AuthorizeJobPoster.call(%{})

    assert conn.status != 302
  end

  test "user is NOT authorized when they did not post the job" do
    user = insert(:user)
    job = insert(:job)
    conn = build_conn(:get, "/jobs/#{job.id}/edit", %{})
            |> setup_session
            |> put_session(:current_user, user.id)
            |> ElixirJobBoard.Plugs.AuthenticateJobPoster.call(%{})
            |> ElixirJobBoard.Plugs.AuthorizeJobPoster.call(%{})

    assert redirected_to(conn) == "/"
  end

  defp setup_session(conn) do
    conn
      |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
      |> Plug.Session.call(@session)
      |> fetch_session
      |> fetch_flash
  end
end
