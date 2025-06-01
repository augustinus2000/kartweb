module ApplicationHelper
    def cart_running?
        `ps aux | grep '[c]art_control.py'`.present?
      end
end
