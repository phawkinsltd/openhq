class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def all_other_users
    User.where("users.id != ?", current_user.id)
  end
  helper_method :all_other_users

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :login
    devise_parameter_sanitizer.for(:accept_invitation) << [:first_name, :last_name, :username]
    # devise_parameter_sanitizer.for(:sign_up) << [:username, :email, :first_name, :last_name]
    # devise_parameter_sanitizer.for(:account_update) << [:username, :email, :first_name, :last_name]
  end

  def get_first_error(object)
    object.errors.full_messages.first
  end

end
