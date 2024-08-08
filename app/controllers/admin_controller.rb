class AdminController < ApplicationController
  before_action :logged_in_user, :require_admin

  def require_admin
    return if current_user.admin?

    flash[:danger] = t "required_admin"
    redirect_to subjects_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".require_login"
    redirect_to login_url
  end
end
