require 'sidekiq/web'
PodcastMix::Application.routes.draw do
  devise_for :users

  authenticate :user, lambda { |u| true } do #u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq', as: :sidekiq
  end

  resource :search, controller: "search"
  root to: "home#index"
end
