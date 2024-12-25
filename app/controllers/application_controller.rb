class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Authentication
  before_action :get_notification

  def get_notification
    @notifications = [
      "Notification 1",
      "Notification 2",
      "Notification 3"
    ]
  end
end
