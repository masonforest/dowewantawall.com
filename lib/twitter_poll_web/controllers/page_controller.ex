defmodule TwitterPollWeb.PageController do
  use TwitterPollWeb, :controller

  def index(conn, _params) do
    token = ExTwitter.request_token("http://localhost:4000/oauth/callback")
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

    render(conn, "index.html", authenticate_url: authenticate_url)
  end
end
