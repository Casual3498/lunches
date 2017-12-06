require 'rails_helper'



RSpec.describe V1::OrdersController, type: :controller do
  
  API_USER_EMAIL = "api_user@example.com" 
  API_USER_PWD = "ndB8hb4xrkl9i48acn98)*#ee!" 

  let!(:lunches_admin) { FactoryBot.create(:user) } #first registered user is lunches admin
  let!(:api_user) { FactoryBot.create(:user, email: API_USER_EMAIL, 
                                            password: API_USER_PWD, 
                                            password_confirmation: API_USER_PWD) }  
  let!(:api_begin_time) { Rails.configuration.api_begin_time }



  describe "GET #index" do
    
    it "returns http success" do

      allow(Time).to receive(:current).and_return(api_begin_time+1.minute)

      user_token = User.find_by_email(API_USER_EMAIL).authentication_token
      post :index, params: { user_email: API_USER_EMAIL, user_token: user_token }
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to have_content('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      order_date = parsed_body["data"]["attributes"]["order_date"]
      expect(order_date).to eq(Date.current.to_s)  

    end

    it "returns http not_acceptable" do

      allow(Time).to receive(:current).and_return(api_begin_time-1.minute)

      user_token = User.find_by_email(API_USER_EMAIL).authentication_token
      post :index, params: { user_email: API_USER_EMAIL, user_token: user_token }
      expect(response).to have_http_status(:not_acceptable)
      expect(response.header['Content-Type']).to have_content('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      errors_detail = parsed_body["errors"][0]["detail"]
      expect(errors_detail).to have_content("You not allowed to get orders list before")  

    end

  end 


end