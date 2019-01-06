defmodule TwitterPollWeb.VotesController do
  import Ecto.Query, only: [from: 2]
  alias TwitterPoll.{Repo,Vote}
  use TwitterPollWeb, :controller

  def create(conn, %{"choice" => choice}) do
    choice = case choice do
      "true" -> true
      "false" -> false
      _ -> raise "invalid choice"
    end

    user_id = get_session(conn, :user_id)
    IO.puts "user_id: #{user_id}"
    vote = Vote.changeset(%Vote{}, %{
      user_id: user_id,
      choice: choice,
    })
    case Repo.insert(vote) do
      {:ok, vote} ->
        IO.inspect vote
        send_resp(conn, :created, "")
      {:error, %{errors: errors}} -> 
        conn
        |> put_status(:bad_request)
        |> json("#{inspect errors}")
    end
  end

  def index(conn, _params) do
    yes_votes =  from vote in Vote, where: vote.choice == true
    no_votes =  from vote in Vote, where: vote.choice == false

    json(conn,%{
      yes_vote_count:  Repo.aggregate(yes_votes, :count, :id),
      no_vote_count:  Repo.aggregate(no_votes, :count, :id),
    })
  end
end
