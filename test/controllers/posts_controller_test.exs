defmodule ElixirJobBoard.PostsControllerTest do
  use ElixirJobBoard.ConnCase
  alias ElixirJobBoard.Job
  import ElixirJobBoard.Factory
  require IEx

  test "GET /posts", %{conn: conn} do
    conn = get conn, "/posts"
    assert html_response(conn, 200)
  end

  test "GET /posts/new", %{conn: conn} do
    conn = get conn, "/posts/new"
    assert html_response(conn, 200)
  end

  test "GET /posts/:id", %{conn: conn} do
    job = insert(:job)
    conn = get conn, "/posts/#{job.id}"
    assert html_response(conn, 200)
  end

  test "GET /posts/:id/edit", %{conn: conn} do
    job = insert(:job)
    conn = get conn, "/posts/#{job.id}/edit"
    assert html_response(conn, 200)
  end

  test "successful POST /posts", %{conn: conn} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "description"   => "a new job",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    conn = post conn, "/posts", %{"job" => job_params}
    assert get_flash(conn, :info) == "Job created successfully."
    assert redirected_to(conn) =~ "/posts"
    assert (length(Repo.all(Job))) > jobs_count
    assert_in_delta(jobs_count, length(Repo.all(Job)), 2)
  end

  test "unsuccessful POST /posts", %{conn: conn} do
    jobs_count = length(Repo.all(Job))
    job_params = %{"title"        => "Something Important",
                  "poster_email"  => "poster.email@example.com",
                  "contact_email" => "contact.email@example.com",
                  "location"      => "Somewhere",
                  "published_at"  => Ecto.DateTime.utc}
    refute Job.changeset(%Job{}, job_params).valid?
    conn = post conn, "/posts", %{"job" => job_params}
    assert html_response(conn, 200)
    assert jobs_count == length(Repo.all(Job))
    assert_in_delta(jobs_count, length(Repo.all(Job)), 1)
  end

  test "successful PATCH /posts/:id", %{conn: conn} do
    job = insert(:job)
    job_params = %{"title" => "Something Important"}
    conn = patch conn, "/posts/#{job.id}", %{"id" => job.id, "job" => job_params}
    assert get_flash(conn, :info) == "Job successfully updated."
    assert redirected_to(conn) =~ "/posts/#{job.id}"
  end

  test "unsuccessful PATCH /posts/:id", %{conn: conn} do
    job = insert(:job)
    job_params = %{"title" => nil}
    conn = patch conn, "/posts/#{job.id}", %{"id" => job.id, "job" => job_params}
    assert html_response(conn, 200)
    refute Job.changeset(job, job_params).valid?
  end
end
