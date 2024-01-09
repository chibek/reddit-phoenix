defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  use DiscussWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be signed in to access this page.")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end
end
