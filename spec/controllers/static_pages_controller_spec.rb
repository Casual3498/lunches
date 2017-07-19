require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #PrivacyNotice" do
    it "returns http success" do
      get :PrivacyNotice
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #ConditionsOfUse" do
    it "returns http success" do
      get :ConditionsOfUse
      expect(response).to have_http_status(:success)
    end
  end

end
