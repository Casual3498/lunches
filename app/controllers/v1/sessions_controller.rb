class V1::SessionsController < Devise::SessionsController  
  skip_before_action :verify_signed_out_user, only: :destroy
  acts_as_token_authentication_handler_for User
  
  before_action :ensure_params_exist, only: :create
  
  respond_to :json


  def create
    puts "=========================== create  SessionsController ============================================="
    resource = User.find_for_database_authentication(:email=>params[:data][:attributes][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:data][:attributes][:password])
      sign_in(:user, resource)
      render json: { "data": {"id": "0", "type": "auth_token", "attributes": {"authentication_token": resource.authentication_token, "email": resource.email}}}, status: :ok, content_type: "application/vnd.api+json"
      return
    end
    invalid_login_attempt
  end


  def destroy

    cu = current_user
    sign_out(resource_name)
    if current_user == nil && cu != nil
      cu.authentication_token = nil
      cu.save!
      render json: { "data": {"id": "0", "type": "logout_answer", "attributes": {"success": true}}}.to_json, status: :ok, content_type: "application/vnd.api+json"
    else
      render json: errors_json("Logout error"), status: :unprocessable_entity, content_type: "application/vnd.api+json"
    end  
  end 




  private 

  def ensure_params_exist

    return unless  params[:data].blank? \
                || params[:data][:type].blank? \
                || params[:data][:type]!="auth_params" \
                || params[:data][:attributes].blank? \
                || params[:data][:attributes][:email].blank? \
                || params[:data][:attributes][:password].blank?

    render json: errors_json("Missing authentication parameter"), status: :unprocessable_entity, content_type: "application/vnd.api+json"

  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: errors_json("Error with your email or password"), status: :unauthorized, content_type: "application/vnd.api+json"
  end  


end