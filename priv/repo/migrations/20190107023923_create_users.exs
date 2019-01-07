defmodule TwitterPoll.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :twitter_user_id, :integer
      add :screen_name, :string
      add :profile_image_url, :string

      timestamps()
    end

  end
end
