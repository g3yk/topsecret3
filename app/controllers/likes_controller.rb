class LikesController < ApplicationController
  before_action :authenticate_user!

  def like
    @post = Post.find(params[:post_id])

    like = @post.likes.find_by(user_id: current_user.id)

    if like.nil?
      @post.likes.create(user_id: current_user.id)
      Notification.create(user_trigger_id: current_user.id, user_target_id: @post.user.id, message: "#{current_user.username} liked your post.")
    else
      like.destroy
      Notification.create(user_trigger_id: current_user.id, user_target_id: @post.user.id, message: "#{current_user.username} took their like off your post.")
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @post.likes.create(user_id: current_user.id)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.likes.find_by(user_id: current_user.id).destroy
    redirect_to root_path
  end

  def index
    @post = Post.find(params[:post_id])
    @likes = @post.likes
  end
end
