class ApplicationController < ActionController::Base
  #protect_from_forgery prepend: true
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session #, prepend: true #, if: Proc.new { |c| c.request.format == 'application/vnd.api+json' }
  # before_action :authenticate_user_from_token!
  # This is Devise's authentication 
  before_action :authenticate_user! #scipped in static_pages_controller.rb and in v1::sessions_controller.rb
  before_action :configure_permitted_parameters, if: :devise_controller?

  #acts_as_token_authentication_handler_for User , fallback: :none
  #acts_as_token_authentication_handler_for User , if: lambda { |controller| controller.request.format.json? }
  #acts_as_token_authentication_handler_for User


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
  # def authenticate_user_from_token!
  #   debugger
  #   user_email = params[:email].presence
  #   user       = user_email && User.find_by_email(user_email)
  #   # Notice how we use Devise.secure_compare to compare the token
  #   # in the database with the token given in the params, mitigating
  #   # timing attacks.
  #   if user && Devise.secure_compare(user.authentication_token, params[:authentication_token])
  #     sign_in user, store: false
  #   else
  #     render  json: errors_json("Unauthorized"), status: 401, content_type: "application/vnd.api+json" 
  #   end
  # end
  def after_successful_token_authentication
    #debugger
    # Make the authentication token to be disposable 
    #renew_authentication_token!
  end
end