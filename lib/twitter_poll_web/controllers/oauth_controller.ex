defmodule TwitterPollWeb.OauthController do
  alias TwitterPoll.Repo
  alias TwitterPoll.User
  use TwitterPollWeb, :controller

  def callback(conn, %{
        "oauth_token" => oauth_token,
        "oauth_verifier" => oauth_verifier
  }
  ) do
        {:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)
        config = Application.fetch_env!(:extwitter, :oauth)
        ExTwitter.configure(
          consumer_key: Keyword.fetch!(config, :consumer_key),
          consumer_secret: Keyword.fetch!(config, :consumer_secret),
          access_token: access_token.oauth_token,
          access_token_secret: access_token.oauth_token_secret
        )
    user = ExTwitter.verify_credentials
    IO.inspect user
        %{
          id: twitter_user_id,
          profile_image_url: profile_image_url,
          screen_name: screen_name,
        } = ExTwitter.verify_credentials

    changes = %{
      profile_image_url: profile_image_url,
      screen_name: screen_name,
    }
    IO.inspect Repo.get_by(User, twitter_user_id: twitter_user_id)
    result =
      case Repo.get_by(User, twitter_user_id: twitter_user_id) do
        nil  -> %User{twitter_user_id: twitter_user_id}
        user -> user
      end
          |> User.changeset(changes)
          |> Repo.insert_or_update

    case result do
      {:ok, user} ->
        IO.inspect user
        conn
          |> put_session(:user_id, Map.fetch!(user, :id))
          |> json(user)
      {:error, _errors} ->
        conn
          |> send_resp(:bad_request, "")
    end

  end

  def authentication_url(conn, %{"state" => state}) do
    token = ExTwitter.request_token("http://localhost:3000/oauth/callback?state=#{state}")
    {:ok, authentication_url} = ExTwitter.authenticate_url(token.oauth_token)

    json conn, authentication_url
  end
end
