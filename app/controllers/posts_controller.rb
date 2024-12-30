class PostsController < ApplicationController
  before_action :authenticate_user!, only: [
    :new,
    :create,
    :edit,
    :update,
    :new,
    :delete,
    :followings_posts
  ]
  before_action :has_permissions?, only: [
    :edit,
    :update,
    :delete
  ]

  def create
    @user = current_user
    @post = @user.posts.create(post_params)

    if @post.save
      @post.avatar.attach(params[:post][:avatar]) if params[:post][:avatar].present?

      @user.followers.each do |follower|
        Notification.create!(
          user_trigger_id: @user.id,
          user_target_id: follower.id,
          message: "#{@user.username} has created a new post."
        )
      end

      redirect_to show_post_path(@post), notice: "Post was successfully created."
    else
      render :new
    end
  end

  def update
    @user = current_user
    @post = @user.posts.find(params[:id])

    if @post.update(post_params)
      @post.avatar.attach(params[:post][:avatar]) if params[:post][:avatar].present?
      redirect_to profile_path, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comments = @post.comments.includes(:user)
    @comments = @post.comments.order(:created_at)

    if @post.nil?
      redirect_to posts_path, alert: "Post not found."
      return
    end

    @user = @post.user
  end

  def delete
    @user = current_user
    @post = current_user.posts.find(params[:id])

    @post.destroy
    redirect_to root_path
  end

  def user_posts
    @user = User.find_by(username: params[:username])
    @posts = @user.posts
  end

  def followings_posts
    @user = current_user
    @posts = Post.where(user_id: @user.followings.pluck(:id)).order(created_at: :desc)
  end

  private

  def has_permissions?
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      render "errors/not_found", locals: {
        error: "Post not found"
      }
      return
    end
    if @post.user != current_user
      render "errors/permission_denied", locals: {
        error: "Post not found"
      }
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :avatar)
  end
end
