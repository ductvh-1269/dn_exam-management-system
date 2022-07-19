class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :current_ability, unless: :devise_controller?
  before_action :set_locale, :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception, prepend: true

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logined_in?
    return if user_signed_in?

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

  def invalid_token
    flash[:danger] = t "invalid_username_password"
    redirect_to :new_user_session
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [%i(email first_name last_name password password_confirmation)])
  end

  private

def current_ability
  controller_name_segments = params[:controller].split("/")
  controller_name_segments.pop
  controller_namespace = controller_name_segments.join("/").camelize
  Ability.new(current_user, controller_namespace)
end

end
