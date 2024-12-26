class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :index,
    :profile
  ]

  def home
  end

  def index
    @user = current_user
    @top_users = User.select("users.*, COUNT(reverse_followships.follower_id) AS followers_count")
      .joins("LEFT JOIN followships AS reverse_followships ON reverse_followships.following_id = users.id")
      .group("users.id")
      .order("followers_count DESC")
      .limit(2)
  end

  def about
  end

  def profile
    @user = current_user
  end

  def contact
  end
end
