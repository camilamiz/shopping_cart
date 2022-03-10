Rails.application.routes.draw do
  post '/checkout', to: 'products#checkout'
end
