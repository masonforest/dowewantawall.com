defmodule TwitterPoll.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TwitterPoll.Vote


  @derive {Poison.Encoder, only: [
    :profile_image_url,
    :screen_name,
    :twitter_user_id,
    :vote,
  ]}
  schema "users" do
    field :profile_image_url, :string
    field :screen_name, :string
    field :twitter_user_id, :integer
    has_one :vote, Vote

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:twitter_user_id, :screen_name, :profile_image_url])
    |> validate_required([:twitter_user_id, :screen_name, :profile_image_url])
  end
end
