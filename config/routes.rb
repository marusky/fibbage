Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get "tv", to: "pages#tv"
  get "admin", to: "pages#admin", constraints: ->(request) { request.params[:code].present? && request.params[:code] == Game.first&.code }
  resource :game do
    member do
      patch "start"
      patch "next_question"
    end
  end

  resource :question, only: [] do
    member do
      patch "open"
      patch "open_voting"
      patch "evaluate"
    end
  end

  resources :answers, only: :create
  resources :votes, only: :create

  resources :players, only: [ :new, :create ]

  get "game", to: "pages#game"

  root "pages#game"
end
