Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "questions#index"

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :rewards, only: :index

  resources :questions do
    resources :answers do
      member do
        patch :mark_as_best
      end
    end
  end

  resources :votes, only: [] do
    collection do
      post ':votable_type/:votable_id/vote_up', to: 'votes#vote_up', as: :vote_up
      post ':votable_type/:votable_id/vote_down', to: 'votes#vote_down', as: :vote_down
      delete ':votable_type/:votable_id/cancel_vote', to: 'votes#cancel_vote', as: :cancel_vote
    end
  end
end
