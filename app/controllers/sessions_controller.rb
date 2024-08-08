class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      log_in @user
      if params.dig(:session,
                    :remember_me) == "1"
        remember(@user)
      else
        forget(@user)
      end
      redirect_back_or root_path
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def load_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end
end
