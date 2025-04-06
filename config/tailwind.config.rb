# config/tailwind.config.rb
Rails.application.config.tailwind.tap do |config|
    config.input_file = "app/assets/stylesheets/application.tailwind.css"
    config.output_file = "app/assets/builds/application.css"  # 반드시 application.css로 변경!
  end
  