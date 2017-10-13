class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, prepend: true, if: Proc.new { |c| c.request.format == 'application/vnd.api+json' }

  before_action :authenticate_user! #scipped in static_pages_controller.rb and in v1::sessions_controller.rb
  before_action :configure_permitted_parameters, if: :devise_controller?
  #acts_as_token_authentication_handler_for User , if: lambda { |controller| controller.request.format.json? }



  #Returns Error hash with received text
  def errors_json(error_text)
      errors = {}
      errors["errors"] = []
      errors["errors"][0] = {}
      errors["errors"][0]["detail"] = error_text
      return errors
  end



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])

  end

  private

  # def after_successful_token_authentication
  #   # Make the authentication token to be disposable 
  #     current_user.authentication_token = nil
  #     current_user.save!
  # end
end