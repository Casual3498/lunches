require 'rails_helper'

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

      it { should have_title('Sign in') }
      it { should have_selector('p.alert.alert-danger') }
      it {should have_error_message('Invalid Email or password')}


      describe "after visiting another page" do
        before { click_link "Lunches" }
        it {should_not have_error_message('')}
      end

    end

    describe "with valid information" do
      let(:user) { FactoryBot.create(:user) }
      before {valid_signin(user)}


      it { should have_content(user.email) }
      it { should have_link('Edit profile',href: edit_user_registration_path) }
      it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

  end





  describe "reset password page" do
    before { visit new_user_password_path }

    it { should have_content('Forgot your password?') }
    
    it { should have_title ("#{base_title} | Forgot password") }
  end



end