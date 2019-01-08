defmodule TwitterPollWeb.UserController do
  require Logger
  alias TwitterPoll.{Repo, User, Vote}
  use TwitterPollWeb, :controller

  def show(conn, _params) do
    user_id = get_session(conn, :user_id)
    Logger.info("Looking up: User ID: #{user_id}")

    if is_nil(user_id) do
      conn
      |> put_status(:not_found)
      |> json(nil)
    else
      user = Repo.get(User, user_id)
        |> Repo.preload(:vote)
      json(conn, user)
    end
  end
end
