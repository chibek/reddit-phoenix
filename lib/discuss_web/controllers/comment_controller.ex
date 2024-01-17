defmodule DiscussWeb.CommentController do
  use DiscussWeb, :controller

  alias Discuss.Discussions

  def delete(conn, %{"id" => id}) do
    comment = Discussions.get_comment!(id)
    {:ok, _comment} = Discussions.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
  end
end
