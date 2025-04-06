Rails.application.routes.draw do
  root 'pages#home'

  post '/start_cart', to: 'carts#start', as: 'start_cart'
  post '/stop_cart', to: 'carts#stop', as: 'stop_cart'

  get '/cart', to: 'carts#show', as: 'cart'  # 장바구니 보기 버튼용
end
