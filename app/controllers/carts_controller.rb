# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def start
    script = "/home/kart/Kart/cart_control.py"
    pid_file = "/home/kart/Kart/cart_pid.txt"

    if File.exist?(pid_file)
      existing_pid = File.read(pid_file).strip
      if system("ps -p #{existing_pid} > /dev/null")
        Rails.logger.info "⚠️ 카트가 이미 실행 중입니다. (PID: #{existing_pid})"
        flash[:alert] = "카트가 이미 실행 중입니다!"
        redirect_to root_path and return
      else
        File.delete(pid_file) # 죽은 프로세스면 PID 파일 삭제
      end
    end

    pid = spawn("python3 #{script}")
    Process.detach(pid)
    File.write(pid_file, pid)

    Rails.logger.info "🟢 카트 시작됨! (PID: #{pid})"
    flash[:notice] = "쇼핑을 시작합니다!"
    redirect_to root_path
  end

  def stop
    pid_file = "/home/kart/Kart/cart_pid.txt"
    log_file = "/home/kart/Kart/cart_log.txt"

    if File.exist?(pid_file)
      pid = File.read(pid_file).strip
      system("kill #{pid}")
      File.delete(pid_file) rescue nil

      Rails.logger.info "🔴 카트 정지됨! (PID: #{pid})"
      File.open(log_file, 'a') { |f| f.puts "[#{Time.now}] 🛑 카트 정지됨 (PID: #{pid})" }

      flash[:alert] = "카트를 정지했습니다!"
    else
      flash[:alert] = "카트 PID를 찾을 수 없습니다!"
    end

    redirect_to root_path
  end

  def show
    @cart_items = session[:cart_items] || []
    @total_price = @cart_items.sum { |item| item["price"] * item["quantity"] }
  end

  def add_dummy
    session[:cart_items] ||= []
    dummy_item = {
      "name" => "테스트 상품",
      "price" => 10000,
      "quantity" => 1,
      "image" => "https://via.placeholder.com/100"
    }
    session[:cart_items] << dummy_item
    flash[:notice] = "테스트 상품이 장바구니에 추가되었습니다!"
    redirect_to cart_path
  end
  
  def increment
    index = params[:id].to_i
    session[:cart_items][index]["quantity"] += 1
    redirect_to cart_path
  end

  def decrement
    index = params[:id].to_i
    session[:cart_items][index]["quantity"] -= 1
    # 수량이 0 이하가 되면 삭제
    session[:cart_items].delete_at(index) if session[:cart_items][index]["quantity"] <= 0
    redirect_to cart_path
  end
  
  def pay
    render :thanks
  end

end
