defmodule TwitterPollWeb.Router do
  use TwitterPollWeb, :router


  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:put_secure_browser_headers)
  end

  scope "/", TwitterPollWeb do
    # Use the default browser stack
    pipe_through(:api)

    get "/user", UserController, :show
    resources "/votes", VotesController, only: [:create, :index]
    get("/", PageController, :index)
    post("/oauth/callback", OauthController, :callback)
    get("/oauth/authentication_url", OauthController, :authentication_url)
  end

  pipeline :api do
    plug CORSPlug, origin: Application.fetch_env!(:cors_plug, :origin)
    plug :accepts, ["json"]
  end
end
