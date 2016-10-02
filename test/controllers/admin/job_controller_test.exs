defmodule ElixirJobBoard.JobControllerTest do
  use ElixirJobBoard.ConnCase
  alias ElixirJobBoard.Job
  alias ElixirJobBoard.User
  import ElixirJobBoard.Factory

  setup do
    user = ElixirJobBoard.Factory.insert(:user, %{ admin: true })
    { :ok, user: Repo.get(User, user.id) }
  end

  test "GET /jobs", %{user: user} do
    conn = build_conn()
            |> assign(:current_user, user)
            |> get("/admin/jobs")
    assert html_response(conn, 200)
  end

  test "GET /jobs/new", %{user: user} do
    conn = build_conn()
            |> assign(:current_user, user)
            |> get("/admin/jobs/new")
    assert html_response(conn, 200)
  end

  test "GET /jobs/:id", %{user: user} do
    job = insert(:job)
    conn = build_conn()
            |> assign(:current_user, user)
            |> get("/admin/jobs/#{job.id}")
    assert html_response(conn, 200)
  end

  test "GET /jobs/:id/edit", %{user: user} do
    job = insert(:job)
    conn = build_conn()
            |> assign(:current_user, user)
            |> get("/admin/jobs/#{job.id}/edit")
    assert html_response(conn, 200)
  end

  test "successful job /jobs", %{user: user} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "description"   => "a new job",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    conn = build_conn()
            |> assign(:current_user, user)
            |> post("/admin/jobs", %{"job" => job_params})
    assert get_flash(conn, :info) == "Job created successfully."
    assert redirected_to(conn) =~ "/admin/jobs"
    assert (length(Repo.all(Job))) > jobs_count
    assert_in_delta(jobs_count, length(Repo.all(Job)), 2)
  end

  test "unsuccessful job /jobs", %{user: user} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    refute Job.changeset(%Job{}, job_params).valid?
    conn = build_conn()
            |> assign(:current_user, user)
            |> post("/admin/jobs", %{"job" => job_params})
    assert html_response(conn, 200)
    assert jobs_count == length(Repo.all(Job))
    assert_in_delta(jobs_count, length(Repo.all(Job)), 1)
  end

  test "successful PATCH /jobs/:id", %{user: user} do
    job = insert(:job)
    job_params = %{"title" => "Something Important"}
    conn = build_conn()
            |> assign(:current_user, user)
            |> patch("/admin/jobs/#{job.id}", %{"id" => job.id, "job" => job_params})
    assert get_flash(conn, :info) == "Job successfully updated."
    assert redirected_to(conn) =~ "/admin/jobs/#{job.id}"
  end

  test "unsuccessful PATCH /jobs/:id", %{user: user} do
    job = insert(:job)
    job_params = %{"title" => nil}
    conn = build_conn()
            |> assign(:current_user, user)
            |> patch("/admin/jobs/#{job.id}", %{"id" => job.id, "job" => job_params})
    assert html_response(conn, 200)
    refute Job.changeset(job, job_params).valid?
  end

  test "DELETE /jobs/:id", %{user: user} do
    job = insert(:job)
    conn = build_conn()
            |> assign(:current_user, user)
            |> delete("/admin/jobs/#{job.id}", %{"id" => job.id})
    assert get_flash(conn, :info) == "Job successfully deleted."
    assert redirected_to(conn) =~ "/admin/jobs"
  end
end
