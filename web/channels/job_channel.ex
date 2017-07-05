defmodule ElixirJobBoard.JobChannel do
  use Phoenix.Channel

  def join("job:markdown", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_markdown", %{"body" => body}, socket) do
    {:ok, html_doc, []} = Earmark.as_html(body)
    broadcast! socket, "new_markdown", %{body: html_doc}
    {:noreply, socket}
  end

  def handle_out("new_markdown", payload, socket) do
    push socket, "new_markdown", payload
    {:noreply, socket}
  end
end
