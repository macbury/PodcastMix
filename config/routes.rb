require 'sidekiq/web'
PodcastMix::Application.routes.draw do
  devise_for :users

  authenticate :user, lambda { |u| true } do #u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq', as: :sidekiq
  end

  get "/test" => "home#index", as: :test
  root to: "home#index"
end
