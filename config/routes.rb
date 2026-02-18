Rails.application.routes.draw do
  resources :github_events, only: [:index, :show] do
    member do
      get :raw_payload
    end
    collection do
      post :fetch
    end
  end
end
