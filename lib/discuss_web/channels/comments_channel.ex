defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  @impl true
  def join("comments:1", payload, socket) do
    {:ok, socket}
    # if authorized?(payload) do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
end
