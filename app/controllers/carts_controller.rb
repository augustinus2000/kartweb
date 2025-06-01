class CartsController < ApplicationController
  protect_from_forgery except: [:yolo_detect]

  PID_FILE = "/tmp/cart_pid"
  STATUS_FILE = "/tmp/cart_alive"

  def cart_running?
    File.exist?(STATUS_FILE)
  end

  def start_cart
    return redirect_to root_path, alert: "이미 실행 중입니다." if cart_running?
  
    new_uuid = SecureRandom.uuid
    Cart.create!(uuid: new_uuid)
    CurrentCart.delete_all
    CurrentCart.create!(cart_uuid: new_uuid)
  
    python_path = "/home/kart/miniforge3/envs/coral/bin/python3.8"
    script_path = "/home/kart/yolo_test/sort_coral_tpu.py"
    cmd = "#{python_path} #{script_path} #{new_uuid}"
  
    begin
      pid = spawn(cmd, out: "/home/kart/cart_log.txt", err: "/home/kart/cart_err.txt")
      File.write(PID_FILE, pid)
  
      # 일단 spawn이 성공했으면 성공으로 간주
      flash[:notice] = "🟢 카트가 시작되었습니다."
    rescue => e
      flash[:alert] = "❌ 카트 시작에 실패했습니다: #{e.message}"
    end
  
    redirect_to root_path
  end
  

  def stop
    if File.exist?(PID_FILE)
      pid = File.read(PID_FILE).to_i
      begin
        Process.kill("TERM", pid)
      rescue Errno::ESRCH
        # 이미 종료된 경우 무시
      end
      File.delete(PID_FILE)
      flash[:notice] = "카트를 정지했습니다."
    else
      flash[:alert] = "카트가 실행 중이 아닙니다."
    end
    redirect_to root_path
  end
  
  def yolo_detect
    cart_uuid = params[:cart_uuid]
    @current_cart = Cart.find_or_create_by(uuid: cart_uuid)
    detected = params[:detected] || []

    detected.each do |name|
      product = Product.find_by(name: name)
      next unless product

      item = @current_cart.cart_items.find_or_initialize_by(product: product)
      item.quantity ||= 0
      item.quantity += 1
      item.save!
    end

    render json: { status: "ok", added: detected }
  end

  def show
    @current_cart = Cart.find_by(uuid: params[:cart_uuid])
    if @current_cart.nil?
      redirect_to root_path, alert: "장바구니가 없습니다"
    else
      @cart_items = @current_cart.cart_items.includes(:product)
      @total_price = @cart_items.sum { |item| item.product.price * item.quantity }
    end
  end

  def increment
    cart_uuid = params[:cart_uuid]
    @current_cart = Cart.find_by(uuid: cart_uuid)
    item = @current_cart.cart_items.includes(:product)[params[:index].to_i]
    item.update(quantity: item.quantity + 1)
    redirect_to cart_path(cart_uuid)
  end

  def decrement
    cart_uuid = params[:cart_uuid]
    @current_cart = Cart.find_by(uuid: cart_uuid)
    item = @current_cart.cart_items.includes(:product)[params[:index].to_i]
    if item.quantity > 1
      item.update(quantity: item.quantity - 1)
    else
      item.destroy
    end
    redirect_to cart_path(cart_uuid)
  end

  def pay
    cart_uuid = params[:cart_uuid]
    @current_cart = Cart.find_by(uuid: cart_uuid)
    @current_cart.cart_items.destroy_all
    redirect_to cart_complete_path
  end

  def complete
  end

  def index
    @current_cart = CurrentCart.first
    if @current_cart
      redirect_to cart_path(@current_cart.cart_uuid)
    else
      render plain: "아직 카트가 시작되지 않았습니다."
    end
  end
  
end
