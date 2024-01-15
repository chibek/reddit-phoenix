defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Discussions
  alias DiscussWeb.Topic
  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Discussions.get_topic!(topic_id)
    IO.inspect(%{comments:  )
    {:ok, %{}, assign(socket, :topic, topic)}
  end

  @impl true
  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic

    case Discussions.create_comment(topic, %{content: content}) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, :error, socket}
    end

  end
end
