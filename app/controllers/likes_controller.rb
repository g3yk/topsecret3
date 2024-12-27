class LikesController < ApplicationController
  before_action :authenticate_user!

  def like
    @post = Post.find(params[:post_id])

    like = @post.likes.find_by(user_id: current_user.id)

    if like.nil?
      @post.likes.create(user_id: current_user.id)
    else
      like.destroy
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
