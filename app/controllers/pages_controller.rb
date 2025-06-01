class PagesController < ApplicationController
  def home
    @active_cart = CurrentCart.first
  end
end
