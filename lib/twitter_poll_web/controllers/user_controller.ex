defmodule TwitterPollWeb.UserController do
  alias TwitterPoll.{Repo,User}
  use TwitterPollWeb, :controller

  def show(conn, _params) do
    user_id = get_session(conn, :user_id)

    case Repo.find(user_id) do
      {:ok, user} ->
        json(conn, user)
      {:error, %{errors: errors}} -> 
        conn
        |> put_status(:bad_request)
        |> json("#{inspect errors}")
    end
  end
end
