defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Discussions
  alias Discuss.Discussions.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Discussions.list_topics()
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Discussions.change_topic(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Discussions.create_topic(conn.assigns.user, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Discussions.get_topic!(id)
    render(conn, :show, topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Discussions.get_topic!(id)
    changeset = Discussions.change_topic(topic)
    render(conn, :edit, topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Discussions.get_topic!(id)

    case Discussions.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Discussions.get_topic!(id)
    {:ok, _topic} = Discussions.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: ~p"/topics")
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    topic = Discussions.get_topic!(topic_id)

    if topic.user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You must be the owner of this post to access this page.")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end
end
