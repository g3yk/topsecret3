class FollowshipsController < ApplicationController
  def follow
    @user = User.find(params[:id])

    if current_user == @user
      redirect_to user_path(@user.username), notice: "You cannot follow yourself."
      return
    end

    current_user.follow(@user)
    Notification.create!(user_trigger_id: current_user.id, user_target_id: @user.id, message: "#{current_user.username} is now following you.")

    redirect_to user_path(@user.username), notice: "You are now following this user."
  end

  def unfollow
    @user = User.find(params[:id])

    if current_user == @user
      redirect_to user_path(@user.username), notice: "You cannot unfollow yourself."
      return
    end

    current_user.unfollow(@user)
    Notification.create!(user_trigger_id: current_user.id, user_target_id: @user.id, message: "#{current_user.username} is no longer following you.")

    redirect_to user_path(@user.username), notice: "You have unfollowed this user."
  end

  def followers
    @user = User.find_by(username: params[:username])

    if @user.nil?
      render "errors/not_found", locals: {
        error: "User `#{params[:username]}` not found"
      }
      return
    end

    @followers = @user.followers
  end

  def followings
    @user = User.find_by(username: params[:username])

    if @user.nil?
      render "errors/not_found", locals: {
        error: "User `#{params[:username]}` not found"
      }
      return
    end

    @followings = @user.followings
  end
end
