require 'rails_helper'

RSpec.describe "UserPages", type: :request do

  let(:base_title) { "Lunches" }

  subject { page }

  describe "signup page" do
    before { visit new_user_registration_path }

    it { should have_content('Sign up') }
    
    it { should have_title ("#{base_title} | Sign up") }
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


end
