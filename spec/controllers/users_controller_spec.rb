require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:lunches_admin) {FactoryBot.create(:user)} #first registered user is lunches admin
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }

  describe "GET #index" do
    before { sign_in lunches_admin }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      expect(assigns(:users)).to match(User.all)
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

  describe "GET #show" do

    it "returns http success" do
      sign_in user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      sign_out user
    end

    it "unsigned user get redirect to Sign in" do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :new, controller: 'devise/sessions'                              
    end

    it "other user get redirect to Home" do
      sign_in other_user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to action: :home, controller: :static_pages  
      sign_out other_user                            
    end 

    it "lunches admin allowed to see other users profiles" do
      sign_in lunches_admin
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      sign_out lunches_admin                            
    end    

  end






end
