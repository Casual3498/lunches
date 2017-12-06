require 'rails_helper'



RSpec.describe V1::SessionsController, type: :controller do
  API_USER_EMAIL =  "api_user@example.com" 
  API_USER_PWD = "ndB8hb4xrkl9i48acn98)*#ee!" 

  let!(:lunches_admin) { FactoryBot.create(:user) } #first registered user is lunches admin
  let!(:api_user) { FactoryBot.create(:user, email: API_USER_EMAIL, 
                                            password: API_USER_PWD, 
                                            password_confirmation: API_USER_PWD) }  


  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end  


  describe "POST #create" do
    it "returns http created" do
      post :create, params: { "data": 
                                { "id": "0", "type": "auth_params", "attributes": 
                                  { "email": API_USER_EMAIL, "password": API_USER_PWD }
                                }
                              }
      expect(response).to have_http_status(:created)
      expect(response.header['Content-Type']).to have_content('application/vnd.api+json')
      expect(response.body).to have_content("authentication_token")
      parsed_body = JSON.parse(response.body)
      user_token = parsed_body["data"]["attributes"]["authentication_token"]
      expect(user_token).to eq(User.find_by_email(API_USER_EMAIL).authentication_token)
    end
  end

 

  describe "DELETE #destroy" do
    it "returns http success" do
      user_token = User.find_by_email(API_USER_EMAIL).authentication_token
      post :destroy, params: { user_email: API_USER_EMAIL, user_token: user_token }
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to have_content('application/vnd.api+json')
      parsed_body = JSON.parse(response.body)
      success = parsed_body["data"]["attributes"]["success"]
      expect(success).to be_truthy      
    end
  end

end
