defmodule Discuss.Discussions.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :user]}
  schema "comments" do
    field :content, :string
    belongs_to :topic, Discuss.Discussions.Topic
    belongs_to :user, Discuss.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
