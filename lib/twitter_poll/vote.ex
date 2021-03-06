defmodule TwitterPoll.Vote do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Poison.Encoder, only: [
    :choice
  ]}
  schema "votes" do
    field :choice, :boolean, default: false
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:user_id, :choice])
    |> validate_required([:user_id, :choice])
    |> unique_constraint(:user_id, message: "already voted")
  end
end
