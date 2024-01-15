defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Discussions
  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Discussions.get_topic!(topic_id)

    {:ok, Jason.encode!(%{comments: topic.comments}), assign(socket, :topic, topic)}
  end

  @impl true
  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    case Discussions.create_comment(user_id, topic, %{content: content}) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, :error, socket}
    end
  end
end
