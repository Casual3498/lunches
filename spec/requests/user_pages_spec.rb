require 'rails_helper'

RSpec.describe "UserPages", type: :request do


  let(:base_title) { "Lunches" }

  subject { page }

  describe "signup page" do
    before { visit new_user_registration_path }

    it { should have_content('Sign up') }
    
    it { should have_title ("#{base_title} | Sign up") }
  end


  describe "signup" do

    before { visit new_user_registration_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Sign up" }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button "Sign up"  }

        it { should have_title('Sign up') }
        it { should have_content('Please review the problems below') }
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email",with: "name@example.com"
        fill_in "Password", with: "123456", :match => :prefer_exact 
        fill_in "Password confirmation", with: "123456", :match => :prefer_exact
      end

      it "should create a user" do
        expect { click_button "Sign up" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Sign up" }
        let(:user) { User.find_by(email: 'name@example.com') }

        it { should have_content(user.email) }
        it { should have_selector('p.alert.alert-success', text: 'Welcome') }
      end


    end
  end




  describe "signin page" do
    before { visit new_user_session_path }

    it { should have_content('Sign in') }
    
    it { should have_title ("#{base_title} | Sign in") }
  end

  describe "reset password page" do
    before { visit new_user_password_path }

    it { should have_content('Forgot your password?') }
    
    it { should have_title ("#{base_title} | Forgot password") }
  end






  describe "profile page" do
   
    let(:user) { FactoryBot.create(:user) }
    before { #sign_in(user)


      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"


      visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end





  # class PostsTest < ActionController::TestCase
  #  include Devise::Test::ControllerHelpers

  #  test 'authenticated users can GET index' do
  #   let(:user) { FactoryBot.create(:user) }
  #   before { sign_in(user)
  #     visit user_path(user) }

  #   it { should have_content(user.name) }
  #   it { should have_title("usme") }

  #    sign_in users(:bob)

  #    get :index
  #    assert_response :success
  #  end
  # end



end
