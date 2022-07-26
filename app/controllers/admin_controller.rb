class AdminController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html{redirect_to root_path, alert: exception.message}
    end
  end
end
