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
        it { should have_error_message('Please review the problems below:') }
      end
    end

    describe "with valid information" do
      before { fill_valid_signup }

      it "should create a user" do
        expect { click_button "Sign up" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Sign up" }
        let(:user) { User.find_by(email: 'name@example.com') }

        it { should have_link('Sign out') }
        it { should have_content(user.email) }
        it { should have_success_message( 'Welcome! You have signed up successfully.') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end        
      end
    end
  end



  describe "profile page" do
   
    let(:user) { FactoryBot.create(:user) }
    before { #sign_in(user)

      visit new_user_session_path
      valid_signin(user)

      visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end




end
