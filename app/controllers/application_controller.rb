class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    rails_admin_path
  end

    protected

  def configure_permitted_parameters
    registration_params = [:name, :functional_id, :telphone, :job_role, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
  end

end
