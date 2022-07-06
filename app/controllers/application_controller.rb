class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  before_action :set_locale, :current_user
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def logined_in?
    return if logged_in?

    flash[:danger] = t ".you_need_to_login"
    redirect_to :login
  end

  def load_per_page per_page
    params[:size] ||= per_page
  end

  def not_found
    flash[:danger] = t "layouts.application.not_found"
    redirect_to root_path
  end
end
