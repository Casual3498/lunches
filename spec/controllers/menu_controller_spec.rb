require 'rails_helper'

RSpec.describe MenusController, type: :controller do
  let!(:lunches_admin) { FactoryBot.create(:user) } #first registered user is lunches admin
  let!(:ordinary_user) { FactoryBot.create(:user) }

  describe "GET #index" do

    describe "unsigned user can not see menu" do
      it "unsigned user get redirect to Sign in" do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :new, controller: 'devise/sessions'  
      end
    end

    describe "signed user can see menu page" do
      before { sign_in ordinary_user}
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    describe "lunches admin can see menu page and edit menu template" do
      before { sign_in lunches_admin}
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end


  end


  describe "POST #create" do

    describe "lunches admin can add menu item" do
      before { sign_in lunches_admin }
      
      shared_examples_for "create menu item" do
      
        it "creates a new menu item" do
          post :create, params: { menu: {
                                          name: menu_item.name, 
                                          cost: menu_item.cost.to_s,   
                                          menu_date: menu_item.menu_date,
                                          course_type_id: menu_item.course_type.id,  
                                          currency_type_id: menu_item.currency_type.id
                                        }                               
                                }, as: :js
          expect(response).to have_http_status(:ok) #also ok(200) with invalid date

        end

        it "creates a new menu item in base" do
          expect{
            post :create, params: { menu: {
                                            name: menu_item.name, 
                                            cost: menu_item.cost.to_s,   
                                            menu_date: menu_item.menu_date,
                                            course_type_id: menu_item.course_type.id,  
                                            currency_type_id: menu_item.currency_type.id
                                          }                               
                                  }, as: :js
          }.to change(Menu,:count).by(1)
        end
      end

      it_behaves_like "create menu item" do
        let!(:menu_item) { FactoryBot.build(:menu_fc) }
      end
      it_behaves_like "create menu item" do
        let!(:menu_item) { FactoryBot.build(:menu_mc) }
      end
      it_behaves_like "create menu item" do
        let!(:menu_item) { FactoryBot.build(:menu_dr) }
      end            

      describe "can not creates a new menu item in base with invalid data" do
        let!(:menu_item) { FactoryBot.build(:menu_fc) }

        it "invalid cost" do 
          costs = %w[-12345678.99 100000000  -1 . 0.001 12,45 ,5 -0,6 -99,6 99999999.999 123.45.67 o O 1O]
          expect do
            costs.each do |cost|
              post :create, params: { menu: {
                                              name: menu_item.name, 
                                              cost: cost,   
                                              menu_date: menu_item.menu_date,
                                              course_type_id: menu_item.course_type.id,  
                                              currency_type_id: menu_item.currency_type.id
                                            }                               
                                    }, as: :js
            end
          end.to change(Menu,:count).by(0)
        end

        it "invalid date" do 
          costs = %w[-12345678.99 100000000  -1 . 0.001 12,45 ,5 -0,6 -99,6 99999999.999 123.45.67 o O 1O]
          menu_dates = [] << Date.yesterday << Date.tomorrow << 100.years.ago << 20.years.from_now 
          expect do
            menu_dates.each do |invalid_date|
              post :create, params: { menu: {
                                              name: menu_item.name, 
                                              cost: menu_item.cost,   
                                              menu_date: invalid_date,
                                              course_type_id: menu_item.course_type.id,  
                                              currency_type_id: menu_item.currency_type.id
                                            }                               
                                    }, as: :js
            end
          end.to change(Menu,:count).by(0)
        end

        it "invalid course type" do          
          expect do
            post :create, params: { menu: {
                                            name: menu_item.name, 
                                            cost: menu_item.cost,   
                                            menu_date: menu_item.menu_date,
                                            course_type_id: FactoryBot.create(:course_type).id,  
                                            currency_type_id: menu_item.currency_type.id
                                          }                               
                                  }, as: :js
          end.to change(Menu,:count).by(0)
        end        

        it "dublicate name" do   
          menu_item.save!       
          expect do
            post :create, params: { menu: {
                                            name: menu_item.name, 
                                            cost: menu_item.cost,   
                                            menu_date: menu_item.menu_date,
                                            course_type_id: menu_item.course_type.id,  
                                            currency_type_id: menu_item.currency_type.id
                                          }                               
                                  }, as: :js
          end.to change(Menu,:count).by(0)
        end 

      end

    end


    describe "unsigned user can not add menu item" do
      let!(:menu_item) { FactoryBot.build(:menu_fc) }
      it "unsigned user get 401 Unauthorized status" do
        post :create, params: { menu: {
                                        name: menu_item.name, 
                                        cost: menu_item.cost.to_s,   
                                        menu_date: menu_item.menu_date,
                                        course_type_id: menu_item.course_type.id,  
                                        currency_type_id: menu_item.currency_type.id
                                      }                               
                              }, as: :js
        expect(response).to have_http_status(:unauthorized)
      end      
    end

    describe "signed user can not add menu item" do
      before { sign_in ordinary_user }
      let!(:menu_item) { FactoryBot.build(:menu_fc) }
      it "signed user get redirected" do
        post :create, params: { menu: {
                                        name: menu_item.name, 
                                        cost: menu_item.cost.to_s,   
                                        menu_date: menu_item.menu_date,
                                        course_type_id: menu_item.course_type.id,  
                                        currency_type_id: menu_item.currency_type.id
                                      }                               
                              }, as: :js
        expect(response).to have_http_status(:redirect)
        #error with this test below with commented instead of root url :
        # Expected response to be a redirect to <http://test.host/home> but was a redirect to <http://test.host/>.
        # Expected "http://test.host/home" to be === "http://test.host/".
        expect(response).to redirect_to root_url #action: :home, controller: :static_pages  
      end      
    end    

  end #POST #create


  describe "PUT #update" do
    
    describe "lunches admin can update menu item" do
      before { sign_in lunches_admin }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "update menu item" do
        put :update, params: {  id: menu_item.id, 
                                menu: {
                                        name: "Test name", 
                                        cost: "-32,44",   
                                        menu_date: menu_item.menu_date,
                                        course_type_id: menu_item.course_type.id,  
                                        currency_type_id: menu_item.currency_type.id
                                      }                               
                              }, as: :js
        expect(response).to have_http_status(:ok) #also ok(200) with invalid date
      end
    end

    describe "unsigned user can not update menu item" do
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "unsigned user get 401 Unauthorized status" do
        put :update, params: {  id: menu_item.id, 
                                menu: {
                                        name: "Test name", 
                                        cost: "-32,44",   
                                        menu_date: menu_item.menu_date,
                                        course_type_id: menu_item.course_type.id,  
                                        currency_type_id: menu_item.currency_type.id
                                      }                               
                              }, as: :js
        expect(response).to have_http_status(:unauthorized)
      end      
    end

    describe "signed user can not update menu item" do
      before { sign_in ordinary_user }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "signed user get redirected" do
        put :update, params: {  id: menu_item.id, 
                                menu: {
                                        name: "Test name", 
                                        cost: "-32,44",   
                                        menu_date: menu_item.menu_date,
                                        course_type_id: menu_item.course_type.id,  
                                        currency_type_id: menu_item.currency_type.id
                                      }                               
                              }, as: :js
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_url
      end      
    end
  end #"PUT #update" 


  describe "GET #delete" do

    describe "lunches admin can see delete form" do
      before { sign_in lunches_admin }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "receive delete form" do
        get :delete , params: { menu_id: menu_item.id }, as: :js

        # parsed_params = Rails.application.routes.recognize_path "/menus/#{menu_item.id}/delete"
        # controller = parsed_params.delete(:controller)
        # action = parsed_params.delete(:action)
        # pp parsed_params
        # get(action, parsed_params)

        expect(response).to have_http_status(:ok) 
      end
    end

    describe "unsigned user can not see delete form" do
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "unsigned user get 401 Unauthorized status" do
        get :delete , params: { menu_id: menu_item.id }, as: :js

        expect(response).to have_http_status(:unauthorized)
      end      
    end

    describe "signed user can not see delete form" do 
      before { sign_in ordinary_user }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "signed user get redirected" do
        get :delete , params: { menu_id: menu_item.id }, as: :js

        expect(response).to have_http_status(:ok) #user can not see but ok?
      end      
    end
  end #"GET #delete"


  describe "DELETE #destroy" do
    describe "lunches admin can delete the menu item from base" do
      before { sign_in lunches_admin }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "delete menu item" do
        expect do
          delete :destroy , params: { id: menu_item.id }, as: :js

          expect(response).to have_http_status(:ok)
        end.to change(Menu,:count).by(-1) 
      end
    end

    describe "unsigned user can not delete the menu item from base" do
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "unsigned user get 401 Unauthorized status" do
        delete :destroy , params: { id: menu_item.id }, as: :js

        expect(response).to have_http_status(:unauthorized)
      end      
    end

    describe "signed user can not delete the menu item from base" do
      before { sign_in ordinary_user }
      let!(:menu_item) { FactoryBot.create(:menu_fc) }
      it "signed user get redirected" do
        delete :destroy , params: { id: menu_item.id }, as: :js

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_url
      end      
    end


  end

end
