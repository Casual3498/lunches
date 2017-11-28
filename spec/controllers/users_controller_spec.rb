require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:lunches_admin) {FactoryBot.create(:user)} #first registered user is lunches admin
  let!(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
    before { sign_in lunches_admin }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    describe "non lunches_admin can not see the list of users" do
      before { sign_out lunches_admin }
      it "unsigned user get redirect to Sign in" do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :new, controller: 'devise/sessions'                              
      end
      it "signed user get redirect to Home" do
        sign_in user
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :home, controller: :static_pages                              
      end      

    end
  end

end
