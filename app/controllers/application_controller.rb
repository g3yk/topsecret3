class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Authentication
  before_action :get_notification

  def get_notification
    if current_user.nil?
      @notifications = []
      return
    end

    @notifications = current_user.notifications.order(created_at: :desc)
  end
end
