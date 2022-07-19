class AdminController < ApplicationController
  before_action :authenticate_admin!, :require_admin, :load_user

  private

  def require_admin
    return if current_user.admin?

    flash[:danger] = t "required_admin"
    redirect_to subjects_path
  end

  def logged_in_user
    return if user_signed_in?

    store_location
    flash[:danger] = t ".require_login"
    redirect_to login_url
  end

  def load_user
    @user = current_user
  end
end
