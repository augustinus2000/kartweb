class CartsController < ApplicationController
    def start
      Rails.logger.info("🟢 카트 시작됨!")
      flash[:notice] = "카트가 시작되었습니다."
      redirect_to root_path
    end
  
    def stop
      Rails.logger.info("🔴 카트 정지됨!")
      flash[:alert] = "카트가 정지되었습니다."
      redirect_to root_path
    end
  
    def show
      # 장바구니 보기용 (나중에 구현)
    end
  end
  