Rails.application.routes.draw do
  root to: 'home#index'

  # This should be the last route to be defined as it is meant to
  # catch all routes not defined in the backend and send back to the
  # root_path so that react handles the frontend routing
  match '*path', to: 'home#index', via: :all
end
