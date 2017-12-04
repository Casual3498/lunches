require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #privacy_notice" do
    it "returns http success" do
      get :privacy_notice
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "GET #conditions_of_use" do
    it "returns http success" do
      get :conditions_of_use
      expect(response).to have_http_status(:success)
    end
  end
end
