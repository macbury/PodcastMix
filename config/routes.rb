require 'sidekiq/web'
PodcastMix::Application.routes.draw do
  devise_for :users

  resources :channels, path: "podcast" do
    member do 
      get :poster
    end
  end

  #authenticate :user, lambda { |u| true } do #u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq', as: :sidekiq
  #end

  resource :search, controller: "search"
  root to: "home#index"
end
