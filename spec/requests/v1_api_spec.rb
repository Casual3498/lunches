require 'rails_helper'



RSpec.describe "V1::api", type: :request do

  API_USER_EMAIL = "api_user@example.com" 
  API_USER_PWD = "ndB8hb4xrkl9i48acn98)*#ee!" 

  let!(:lunches_admin) { FactoryBot.create(:user) } #first registered user is lunches admin
  let!(:api_user) { FactoryBot.create(:user, email: API_USER_EMAIL, 
                                            password: API_USER_PWD, 
                                            password_confirmation: API_USER_PWD) } 
  let!(:api_begin_time) { Rails.configuration.api_begin_time }


  

  describe "signed user can see orders via api at specific time" do

    user_token = ""  #pass to index and destroy to test get and destroy without session

    login_headers = { "Accept": "application/vnd.api+json", 
                      "Content-Type": "application/vnd.api+json" }
    orders_logout_headers = { "Accept": "application/vnd.api+json", 
                      "Content-Type": "application/vnd.api+json",
                      "X-User-Email": API_USER_EMAIL,
                      "X-User-Token": user_token }
    orders_logout_headers_w_invalid_token = { "Accept": "application/vnd.api+json", 
                  "Content-Type": "application/vnd.api+json",
                  "X-User-Email": API_USER_EMAIL,
                  "X-User-Token": "error" }                  
    
    it "user can login, receive authentication token, get orders and logout" do
      #login and receive token
      post v1_login_path, params: { "data": 
                                    { "id": "0", "type": "auth_params", "attributes": 
                                      { "email": API_USER_EMAIL, "password": API_USER_PWD }
                                    }
                                  }, headers: login_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq("application/vnd.api+json")
      #expect(response.body).to have_content("authentication_token") not worked instead of v1_session_controller_spec.rb the same worked
      expect(response.body).to include("authentication_token")
      parsed_body = JSON.parse(response.body)
      user_token = parsed_body["data"]["attributes"]["authentication_token"]
      expect(user_token).to eq(User.find_by_email(API_USER_EMAIL).authentication_token)   

      #could not receive orders for today too early
      allow(Time).to receive(:current).and_return(api_begin_time-1.minute)
      get v1_orders_path, headers: orders_logout_headers, as: :json
      expect(response).to have_http_status(:not_acceptable)
      expect(response.header['Content-Type']).to include('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"]
      expect(errors_detail).to include("You not allowed to get orders list before") 

      #could receive orders for today
      allow(Time).to receive(:current).and_return(api_begin_time+1.minute)
      get v1_orders_path, headers: orders_logout_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to include('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      order_date = parsed_body["data"]["attributes"]["order_date"]
      expect(order_date).to eq(Date.current.to_s)  

      # #could not sign out with invalid token
      # #not worked now - token not needed by destroy, but api_v1_sh tell error without token
      # delete v1_logout_path, params: { user_email: API_USER_EMAIL, user_token: "1" }
      # expect(response).to have_http_status(:unauthorized)
      # expect(response.header['Content-Type']).to include('application/vnd.api+json')
      # parsed_body = JSON.parse(response.body)
      # pp parsed_body
      # pp "----------"
      # # errors_detail = parsed_body["errors"][0]["detail"] 
      # # expect(errors_detail).to eq("Logout error")     
    

      #sign out
      delete v1_logout_path, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to include('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      success = parsed_body["data"]["attributes"]["success"]
      expect(success).to be_truthy    

      #could receive orders after logout
      allow(Time).to receive(:current).and_return(api_begin_time+1.minute)
      get v1_orders_path, headers: orders_logout_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(response.header['Content-Type']).to include('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"] 
      expect(errors_detail).to eq("You need to sign in or sign up before continuing.") 

    end

    it "user can not login with wrong password" do
      post v1_login_path, params: { "data": 
                                    { "id": "0", "type": "auth_params", "attributes": 
                                      { "email": API_USER_EMAIL, "password": API_USER_PWD+"1" }
                                    }
                                  }, headers: login_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq("application/vnd.api+json")
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"] 
      expect(errors_detail).to eq("Error with your email or password")    
    end


    it "user can not logout after session closed" do
      delete v1_logout_path, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(response.header['Content-Type']).to include('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"] 
      expect(errors_detail).to eq("Logout error")      
    end

    it "user can not receive orders after session closed" do
      #could receive orders for today
      allow(Time).to receive(:current).and_return(api_begin_time+1.minute)
      get v1_orders_path, headers: orders_logout_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq("application/vnd.api+json")
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"] 
      expect(errors_detail).to eq("You need to sign in or sign up before continuing.")   
    end 

  end

end
