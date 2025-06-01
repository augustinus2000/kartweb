Rails.application.routes.draw do
  root "home#index"
  
  get "cart", to: "carts#index", as: "cart_index"
  post "cart/start", to: "carts#start_cart", as: "cart_start"
  post "cart/stop", to: "carts#stop", as: "cart_stop"
  post "cart/yolo_detect", to: "carts#yolo_detect", as: "cart_yolo_detect"
  get "cart/:cart_uuid", to: "carts#show", as: "cart"
  post "cart/:cart_uuid/increment/:index", to: "carts#increment", as: "cart_increment"
  post "cart/:cart_uuid/decrement/:index", to: "carts#decrement", as: "cart_decrement"
  post "cart/:cart_uuid/pay", to: "carts#pay", as: "cart_pay"
  get "cart_complete", to: "carts#complete"
end
