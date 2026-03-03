# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :require_admin!
  before_action :set_user, only: %i[show edit update change_role]

  def index
    @users = User.includes(:posts).recent.page(params[:page]).per(20)
    @users = @users.where(role: params[:role]) if params[:role].present?
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def change_role
    @user.update!(role: params[:role])
    redirect_back fallback_location: admin_users_path, notice: "Role updated to #{params[:role]}."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :bio, :website, :twitter_handle, :newsletter_subscribed)
  end
end
