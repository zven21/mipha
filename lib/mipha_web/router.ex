defmodule MiphaWeb.Router do
  use MiphaWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

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
    get   "/search", SearchController, :index
    get   "/search/users", SearchController, :users
    get   "/markdown", PageController, :markdown
    get   "/join", SessionController, :new, as: :join
    post  "/join", SessionController, :create, as: :join
    get   "/rucaptcha", SessionController, :rucaptcha
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
    get "/forgot_password", UserController, :forgot_password
    get "/reset_password", UserController, :reset_password
    get "/verify", UserController, :verify_email
    put "/users/update_password", UserController, :update_password
    post "/users/sent_forgot_password_email", UserController, :sent_forgot_password_email
    post "/users/sent_verify_email", UserController, :sent_verify_email
    resources "/teams", TeamController
    get "/teams/:id/people", TeamController, :people

    # topic
    get "/topics/jobs", TopicController, :jobs
    get "/topics/no_reply", TopicController, :no_reply
    get "/topics/popular", TopicController, :popular
    get "/topics/featured", TopicController, :featured
    get "/topics/educational", TopicController, :educational

    post "/topics/:id/star", TopicController, :star
    post "/topics/:id/unstar", TopicController, :unstar
    post "/topics/:id/collection", TopicController, :collection
    post "/topics/:id/uncollection", TopicController, :uncollection
    post "/topics/:id/suggest", TopicController, :suggest
    post "/topics/:id/unsuggest", TopicController, :unsuggest
    post "/topics/:id/close", TopicController, :close
    post "/topics/:id/open", TopicController, :open
    post "/topics/:id/excellent", TopicController, :excellent
    post "/topics/:id/normal", TopicController, :normal

    resources "/topics", TopicController do
      resources "/replies", ReplyController do
        post "/star", ReplyController, :star
        post "/unstar", ReplyController, :unstar
      end
    end

    resources "/notifications", NotificationController, only: ~w(index)a
    post "/notifications/make_read", NotificationController, :make_read
    delete "/notifications/clean", NotificationController, :clean

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
    resources "/notifications", NotificationController
  end

  # Other scopes may use custom stacks.
  scope "/api", MiphaWeb do
    pipe_through :api

    post "/topics/preview", TopicController, :preview
    post "/callback/qiniu", CallbackController, :qiniu
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
