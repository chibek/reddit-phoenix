defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Accounts
  alias Discuss.Accounts.User

  def callback(
        %{assigns: %{ueberauth_auth: auth}} = conn,
        %{"provider" => provider} = _params
      ) do
    user_params = %{
      token: auth.credentials.token,
      provider: provider,
      email: auth.info.email
    }

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome #{user.email}!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/topics")

      {:error, reason} ->
        {:error, reason}

        conn
        |> put_flash(:error, "Unable to sign in.")
        |> redirect(to: ~p"/topics")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/topics")
  end

  defp insert_or_update_user(changeset) do
    case Accounts.find_user(email: changeset.changes.email) do
      nil ->
        Accounts.create_user(changeset.changes)

      user ->
        {:ok, user}
    end
  end
end
