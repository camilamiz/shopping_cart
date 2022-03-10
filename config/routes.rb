Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/checkout', to: 'products#checkout'
    end
  end
end
