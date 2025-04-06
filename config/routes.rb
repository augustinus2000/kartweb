Rails.application.routes.draw do
  root 'pages#home'

  post '/start_cart', to: 'carts#start', as: 'start_cart'
  post '/stop_cart', to: 'carts#stop', as: 'stop_cart'
  get '/cart', to: 'carts#show', as: 'cart'
  post '/cart/add_dummy', to: 'carts#add_dummy', as: 'add_dummy_item'
  match '/cart/pay', to: 'carts#pay', via: [:get, :post], as: 'pay_cart'

  # 👉 수량 증가/감소 라우트 추가
  post '/cart/increment/:id', to: 'carts#increment', as: 'cart_increment'
  post '/cart/decrement/:id', to: 'carts#decrement', as: 'cart_decrement'
end