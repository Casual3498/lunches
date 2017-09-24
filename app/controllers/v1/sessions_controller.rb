class V1::SessionsController < ApplicationController
skip_before_action :authenticate_user! #, only: [:create]
  
  def create
    user = User.where(email: params[:email]).first  

    if user&.valid_password?(params[:password])
      render json: user.as_json(only: [:email, :authentication_token]), status: :created
    else

      errors = {}
      errors["errors"] = []
      errors["errors"][0] = {}
      errors["errors"][0]["detail"] = "Error login or password"     

      render json: errors, status: 401, content_type: "application/vnd.api+json"


    end
  end

  def destroy
    debugger
    current_user.authentication_token = nil
    if current_user.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end

end