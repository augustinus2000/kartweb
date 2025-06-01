class ApplicationController < ActionController::Base
  before_action :set_cart

  private

  def set_cart
    session[:cart_uuid] ||= SecureRandom.uuid
    @current_cart = Cart.find_or_create_by(uuid: session[:cart_uuid])
  end

  def cart_running?
    `ps aux | grep '[s]ort_coral_tpu.py'`.present?
  end
  
end