defmodule ElixirJobBoard.JobsControllerTest do
  use ElixirJobBoard.ConnCase
  alias ElixirJobBoard.Job
  import ElixirJobBoard.Factory
  require IEx

  @session  Plug.Session.init([
    store:            :cookie,
    key:              "_app",
    encryption_salt:  "secret",
    signing_salt:     "secret",
    encrypt:          false
  ])

  setup do
    conn = build_conn()
            |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
            |> Plug.Session.call(@session)
            |> fetch_session
            |> fetch_flash

    {:ok, conn: conn}
  end

  test "GET /jobs", %{conn: conn} do
    conn = get conn, "/jobs"
    assert html_response(conn, 200)
  end

  test "GET /jobs/new", %{conn: conn} do
    conn = get conn, "/jobs/new"
    assert html_response(conn, 200)
  end

  test "GET /jobs/:id", %{conn: conn} do
    job = insert(:job)
    conn = get conn, "/jobs/#{job.id}"
    assert html_response(conn, 200)
  end

  test "GET /jobs/:id/edit with a valid user", %{conn: conn} do
    user = insert(:user)
    job = insert(:job, user_id: user.id)
    conn = conn
            |> assign(:current_user, user)
            |> get("/jobs/#{job.id}/edit")
    assert html_response(conn, 200)
  end

  test "GET /jobs/:id/edit without a valid user", %{conn: conn} do
    job = insert(:job)
    conn = conn
            |> get("/jobs/#{job.id}/edit")
    assert get_flash(conn, :info) =~ "logged in"
    assert redirected_to(conn) =~ "/"
  end

  test "successful POST /jobs", %{conn: conn} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "description"   => "a new job",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    conn = post conn, "/jobs", %{"job" => job_params}
    assert get_flash(conn, :info) == "Job created successfully."
    assert redirected_to(conn) =~ "/jobs"
    assert (length(Repo.all(Job))) > jobs_count
    assert_in_delta(jobs_count, length(Repo.all(Job)), 2)
  end

  test "unsuccessful POST /jobs", %{conn: conn} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    refute Job.changeset(%Job{}, job_params).valid?
    conn = post conn, "/jobs", %{"job" => job_params}
    assert html_response(conn, 200)
    assert jobs_count == length(Repo.all(Job))
    assert_in_delta(jobs_count, length(Repo.all(Job)), 1)
  end

  test "successful PATCH /jobs/:id with a valid user", %{conn: conn} do
    user = insert(:user)
    job = insert(:job, user_id: user.id)
    job_params = %{"title" => "Something Important"}
    conn = conn
            |> assign(:current_user, user)
            |> patch("/jobs/#{job.id}", %{"id" => job.id, "job" => job_params})
    assert get_flash(conn, :info) == "Job successfully updated."
    assert redirected_to(conn) =~ "/jobs/#{job.id}"
  end

  test "unsuccessful PATCH /jobs/:id with a valid user", %{conn: conn} do
    user = insert(:user)
    job = insert(:job, user_id: user.id)
    job_params = %{"title" => nil}
    conn = conn
            |> assign(:current_user, user)
            |> patch("/jobs/#{job.id}", %{"id" => job.id, "job" => job_params})
    assert html_response(conn, 200)
    refute Job.changeset(job, job_params).valid?
  end
end
