require 'rails_helper'
#include Devise::Test::IntegrationHelpers
# include MyModule

RSpec.describe "Authentication", type: :request do

  let(:base_title) { "Lunches" }

  subject { page }


  describe "signin page" do
    before { visit new_user_session_path }

    it { should have_content('Sign in') }
    
    it { should have_title ("#{base_title} | Sign in") }

  end

  describe "signin" do
    before { visit new_user_session_path }


    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title("#{base_title} | Sign in") }
      it { should have_selector('p.alert.alert-danger') }
      it {should have_error_message('Invalid Email or password')}


      describe "after visiting another page" do
        before { click_link "Lunches" }
        it {should_not have_error_message('')}
      end

    end

    describe "with valid information" do
      let!(:user) { FactoryBot.create(:user) }
      before { valid_signin(user) }


      it { should have_content(user.email) }
      it { should have_link('Menus',href: menus_path) }
      it { should have_link('Edit profile',href: edit_user_registration_path) }
      it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }

      #admin
      it { should have_link('Users',href: users_path) }
      it { should have_link('Orders',href: all_orders_path) }


      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let!(:user) { FactoryBot.create(:user) }


      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_registration_path
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
             #Rails.logger.debug "-------------------------------------"
            expect(page).to have_title("#{base_title} | Edit User")
          end


          describe "when signing in again" do
            before do
              click_link "Sign out"
              visit new_user_session_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (home) page" do
              #home page have only base_title
              expect(page).to have_css 'title', text: /^#{base_title}$/, visible: false 
            end
          end

        end

      end




      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_registration_path }
          it { should have_title("#{base_title} | Sign in") }
        end

        describe "submitting to the update action" do
          before { patch user_registration_path, params: { user: { name: user.name, 
                                                                  email: user.email,  
                                                                  current_password: user.password } }  }
          specify { expect(response).to redirect_to(new_user_session_path) }
        end

        describe "visiting the show page" do
          before { visit user_path(user) }
          it { should have_title("#{base_title} | Sign in") }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title("#{base_title} | Sign in") }
        end

      end
    end

    describe "as wrong user" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:wrong_user) { FactoryBot.create(:wrong_user) }
      before { valid_signin user, no_capybara: true }
      specify{ expect(controller.current_user).to eq(user) }

      # describe "submitting a GET request to the Users#edit action" do

      #   before { 
 
      #     get edit_user_registration_path
      #     # , params: { user: { name: wrong_user.name, 
      #     #                                                         email: wrong_user.email, 
      #     #                                                         current_password: wrong_user.password } }  
      #     }
      #   specify { expect(response.body).not_to match(full_title('Edit user')) }
      #   specify { expect(response).to redirect_to(root_url) }
      # end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_registration_path, params: { user: { name: wrong_user.name, 
                                                                email: wrong_user.email } } }
        
        specify { #Rails.logger.debug response.body
        #  expect(response).to redirect_to(root_url) 
          expect(response).to have_http_status(:success)
        }

        specify { expect(response.body).to match('Please review the problems below') }
   
        #it { have_error_message('Please review the problems below:')  }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_registration_path, params: { user: { name: wrong_user.name, 
                                                                email: wrong_user.email } } }   
        specify { expect(response).to have_http_status(:success) }
        specify { expect(response.body).to match('Please review the problems below') }
      end



      # describe "visiting other user show page" do

      #   before { visit user_path(wrong_user) }
      #   it { should have_title("#{base_title} | Sign in") }
      # end
      # describe "getting other user show page" do

      #   before { get user_path(wrong_user) }
      #   it { should  have_error_message('You not allowed to see other users profiles.') }
      # end


      # describe "visiting user show page" do
      #   before { get user_path(user) }

      #   #it { should have_title("#{base_title} | #{user.name}") }неу
      #   specify { expect(response.body).to match("#{base_title} | #{user.name}") }
      # end


    end



  end




  describe "reset password page" do
    before { visit new_user_password_path }

    it { should have_content('Forgot your password?') }
    
    it { should have_title ("#{base_title} | Forgot password") }
  end



end