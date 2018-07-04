defmodule MiphaWeb.Router do
  use MiphaWeb, :router

  pipeline :browser do
    plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MiphaWeb.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :put_layout, {MiphaWeb.LayoutView, :admin}
  end

  scope "/auth", MiphaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", MiphaWeb do
    # Use the default browser stack
    pipe_through :browser

    get   "/", PageController, :index
    get   "/about", PageController, :about
    get   "/markdown", PageController, :markdown
    get   "/join", SessionController, :new, as: :join
    post  "/join", SessionController, :create, as: :join
    get   "/login", AuthController, :login
    get   "/logout", AuthController, :delete, as: :logout

    get   "/u/:name", UserController, :show
    get   "/u/:name/topics", UserController, :topics, as: :user_topics
    get   "/u/:name/replies", UserController, :replies, as: :user_replies
    get   "/u/:name/stars", UserController, :stars, as: :user_stars
    get   "/u/:name/collections", UserController, :collections, as: :user_collections
    post  "/u/:name/follow", UserController, :follow, as: :user_follow
    post  "/u/:name/unfollow", UserController, :unfollow, as: :user_unfollow
    get   "/u/:name/followers", UserController, :followers, as: :user_followers
    get   "/u/:name/following", UserController, :following, as: :user_following
    get   "/u/:name/reward", UserController, :reward, as: :user_reward

    get "/users", UserController, :index
    resources "/teams", TeamController
    resources "/topics", TopicController
    resources "/notifications", NotificationController, only: ~w(index)a
    resources "/locations", LocationController, only: ~w(index show)a
    resources "/companies", CompanyController, only: ~w(index show)a

    # User profile
    resources "/setting", SettingController, only: ~w(show update)a, singleton: true do
      get "/account", SettingController, :account, as: :account
      get "/password", SettingController, :password, as: :password
      get "/profile", SettingController, :profile, as: :profile
      get "/reward", SettingController, :reward, as: :reward
    end
  end

  scope "/admin", MiphaWeb.Admin, as: :admin do
    pipe_through ~w(browser admin)a

    get "/", PageController, :index
    resources "/users", UserController
    resources "/nodes", NodeController
    resources "/topics", TopicController
    resources "/repies", ReplyController
    resources "/companies", CompanyController
    resources "/teams", TeamController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MiphaWeb do
  #   pipe_through :api
  # end
end
