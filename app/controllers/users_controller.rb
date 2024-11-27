class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :destroy, :change_password, :destroy, :update_password ]

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to login_path, notice: "Successfully registered!"
    else
      render :sign_up, status: :unprocessable_entity
    end
  end

  def sign_up
    @user = User.new
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  def change_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        redirect_to root_path, notice: "Account updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      current_user.errors.add(:base, "Incorrect password")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :unconfirmed_email)
  end
end
