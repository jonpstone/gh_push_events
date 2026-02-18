Rails.application.routes.draw do
  resources :github_events, only: [:index, :show] do
    collection do
      post :fetch
    end
  end
end
