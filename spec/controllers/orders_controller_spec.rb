require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:lunches_admin) { FactoryBot.create(:user) } #first registered user is lunches admin
  let!(:ordinary_user) { FactoryBot.create(:user) }

  describe "GET #index" do

    describe "unsigned user can not see order" do
      it "unsigned user get redirect to Sign in" do
        get :index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :new, controller: 'devise/sessions'  
      end
    end

    shared_examples_for "signed user can see order" do
      before { sign_in user }
      it "returns http success for today menu" do
        get :index, params: { order_date: Date.current.to_s }, as: :js
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
      it "returns http success for week ago menu" do
        get :index, params: { order_date: (1.week.ago.to_date).to_s }, as: :js
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end      
      it "get redirected if no order_date param" do
        get :index, as: :js
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_url
      end         
    end

    it_behaves_like "signed user can see order" do
      let!(:user) { ordinary_user }
    end
    it_behaves_like "signed user can see order" do
      let!(:user) { lunches_admin }
    end

  end # "GET #index"


  describe "POST #create" do
      let!(:menu_fc) { FactoryBot.create(:menu_fc) }
      let!(:menu_mc) { FactoryBot.create(:menu_mc) }
      let!(:menu_dr) { FactoryBot.create(:menu_dr) }

    shared_examples_for "signed user can add order today" do
      before { sign_in user}
      it "create new order" do
        post :create, params: { :order => { order_date: Date.current }, 
                                "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                "order_item#{menu_mc.course_type.id}" => menu_mc.id,
                                "order_item#{menu_dr.course_type.id}" => menu_dr.id                              
                              }, as: :js
        expect(response).to have_http_status(:ok) #also ok(200) with invalid data
      end
      it "create new order in base" do
        expect{
          post :create, params: { :order => { order_date: Date.current }, 
                                  "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                  "order_item#{menu_mc.course_type.id}" => menu_mc.id,
                                  "order_item#{menu_dr.course_type.id}" => menu_dr.id                                 
                                }, as: :js
        }.to change(Order,:count).by(3)
      end

      describe "can not create order with invalid data" do
        let!(:old_menu_fc) { FactoryBot.create(:menu_fc_skips_validate, menu_date: 1.week.ago.to_date) }
        let!(:old_menu_mc) { FactoryBot.create(:menu_mc_skips_validate, menu_date: 1.week.ago.to_date) }
        let!(:old_menu_dr) { FactoryBot.create(:menu_dr_skips_validate, menu_date: 1.week.ago.to_date) }

        it "old order on old menu date" do
          expect{
            post :create, params: { :order => { order_date: old_menu_fc.menu_date }, 
                                    "order_item#{old_menu_fc.course_type.id}" => old_menu_fc.id,
                                    "order_item#{old_menu_mc.course_type.id}" => old_menu_mc.id,
                                    "order_item#{old_menu_dr.course_type.id}" => old_menu_dr.id  
                                 
                                  }, as: :js
          }.to change(Order,:count).by(0)
        end

        it "new order on old menu date" do
          expect{
            post :create, params: { :order => { order_date: Date.current }, 
                                    "order_item#{old_menu_fc.course_type.id}" => old_menu_fc.id,
                                    "order_item#{old_menu_mc.course_type.id}" => old_menu_mc.id,
                                    "order_item#{old_menu_dr.course_type.id}" => old_menu_dr.id  
                                 
                                  }, as: :js
          }.to change(Order,:count).by(0)
        end      
        it "old order on new menu date" do
          expect{
            post :create, params: { :order => { order_date: old_menu_fc.menu_date }, 
                                    "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                    "order_item#{menu_mc.course_type.id}" => menu_mc.id,
                                    "order_item#{menu_dr.course_type.id}" => menu_dr.id  
                                 
                                  }, as: :js
          }.to change(Order,:count).by(0)
        end  

        it "same course types in one order and same order_item params" do
          expect{
            post :create, params: { :order => { order_date: Date.current }, 
                                    "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                    "order_item#{menu_fc.course_type.id}" => FactoryBot.create(:menu_fc) ,
                                    "order_item#{menu_dr.course_type.id}" => menu_dr.id  
                                 
                                  }, as: :js
          }.to change(Order,:count).by(0)
        end  

        it "same course types in one order and different order_item params" do
          expect{
            post :create, params: { :order => { order_date: Date.current }, 
                                    "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                    "order_item#{menu_mc.course_type.id}" => FactoryBot.create(:menu_fc) ,
                                    "order_item#{menu_dr.course_type.id}" => menu_dr.id  
                                 
                                  }, as: :js
          }.to change(Order,:count).by(0)
        end  
      end

    end #shared_examples_for "signed user can add order today"

    it_behaves_like "signed user can add order today" do
      let!(:user) { ordinary_user }
    end
    it_behaves_like "signed user can add order today" do
      let!(:user) { lunches_admin }
    end


    describe "unsigned user can not add order today" do
      it "unsigned user get redirect to Sign in" do
        post :create, params: { :order => { order_date: Date.current }, 
                                "order_item#{menu_fc.course_type.id}" => menu_fc.id,
                                "order_item#{menu_mc.course_type.id}" => menu_mc.id,
                                "order_item#{menu_dr.course_type.id}" => menu_dr.id                              
                              }, as: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end #"POST #create"


  describe "GET #all_index" do

    describe "unsigned user can not see all orders" do
      it "unsigned user get redirect to Sign in" do
        get :all_index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to action: :new, controller: 'devise/sessions'  
      end
    end

    describe "signed user can not see all orders" do
      before { sign_in ordinary_user }
      it "signed user get redirected" do
        get :all_index
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to root_url  
      end      
    end 

    describe "lunches admin can see all orders" do
      before { sign_in lunches_admin }

      it "returns http success for get all orders" do
        get :all_index, params: { order_date: Date.current.to_s }, as: :js
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:all_index)
      end

      it "returns http success for get all orders no js" do
        get :all_index, params: { order_date: Date.current.to_s }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:all_index)
      end

      it "returns http success for week ago menu" do
        get :all_index, params: { order_date: (1.week.ago.to_date).to_s }, as: :js
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:all_index)
      end      

    end        
  end  #"GET #all_index"

  #from menus page show menu item
  describe "GET #show" do
    let!(:menu_mc) { FactoryBot.create(:menu_mc) }

    describe "unsigned user can not see menu_item" do
      it "unsigned user get unauthorized" do
        get :show, params: {id: menu_mc.id  }, as: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    shared_examples_for "signed user can see menu item" do
      before { sign_in user }
      it "returns http success" do
        get :show, params: { id: menu_mc.id }, as: :js
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end     
    end

    it_behaves_like "signed user can see menu item" do
      let!(:user) { ordinary_user }
    end
    it_behaves_like "signed user can see menu item" do
      let!(:user) { lunches_admin }
    end

  end

end
