Rails.application.routes.draw do
  resources :users, only: [:create, :update, :show]

  resources :sessions, only: [:create, :show] do
    collection do
      delete :revoke
    end
  end
end
