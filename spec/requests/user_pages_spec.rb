require 'rails_helper'

RSpec.describe "UserPages", type: :request do


  let(:base_title) { "Lunches" }

  subject { page }


  describe "index" do
    before do
      sign_in FactoryBot.create(:user)
      FactoryBot.create(:user, name: "Bob", email: "bob@example.com")
      FactoryBot.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('Users') }
    it { should have_content('Users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
  end



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
        it { should_not have_link('Sign in') }
        it { should_not have_link('Sign up') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
          it { should have_link('Sign up') }
        end        
      end
    end
  end



  describe "profile page" do
    let!(:lunches_admin) {FactoryBot.create(:user)}
    let!(:user) { FactoryBot.create(:user) }
    
    before do #sign_in(user)
      lunches_admin.save #if not save then user will be lunches_admin as first registered
      visit new_user_session_path
      valid_signin(user)

      visit user_path(user)
    end

    describe "it is not lunches admin" do
      it { should_not have_content("YOU ARE THE LUNCHES ADMIN")}
      it { should_not have_link("Orders")}
      it { should_not have_link("Users")}
    end

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "same test for lunches admin" do
      before do
        click_link "Sign out" 
        visit new_user_session_path
        valid_signin(lunches_admin)
        visit user_path(lunches_admin)
      end
      
      describe "it is lunches admin" do
        it { should have_content("YOU ARE THE LUNCHES ADMIN")}
        it { should have_link("Orders")}
        it { should have_link("Users")}
      end

      it { should have_content(lunches_admin.name) }
      it { should have_title(lunches_admin.name) }
    end 
  end


  describe "edit" do
    let!(:lunches_admin) {FactoryBot.create(:user)}
    let!(:user) { FactoryBot.create(:user) }
    before do  
      lunches_admin.save #if not save then user will be lunches_admin as first registered
      visit new_user_session_path
      valid_signin(user)
      visit edit_user_registration_path(user)
    end

    describe "it is not lunches admin" do
      it { should_not have_content("YOU ARE THE LUNCHES ADMIN")}
      it { should_not have_link("Orders")}
      it { should_not have_link("Users")}
    end

    describe "page" do
      it { should have_content("Edit User") }
      it { should have_title("Edit User") }
    end

    describe "with invalid information" do
      before { click_button "Update" }

      it { should have_error_message('Please review the problems below:')  }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:new_password) { "123456" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: new_password
        fill_in "Password confirmation", with: new_password
        fill_in " Current password", with: user.password
        click_button "Update"
      end


      it { should have_content(new_email) }
      it { should have_success_message( 'Your account has been updated successfully.') }      
      it { should have_link('Sign out', href: destroy_user_session_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
      specify { expect(::BCrypt::Password.new("#{user.reload.encrypted_password}") ).to eq new_password }
    end

    describe "cancel registration (delete user)" do

      it { should have_link('Cancel my account') }

        it "should be able to cancel registration" do
          expect do
            click_link('Cancel my account')

          end.to change(User, :count).by(-1)

          should have_success_message( 'Bye! Your account has been successfully cancelled. We hope to see you again soon.')
          should have_link('Sign in')
          should have_link('Sign up')
          should_not have_link('Sign out')
        end
    end

    describe "same test for lunches admin" do
      before do   
        click_link "Sign out"    
        visit new_user_session_path
        valid_signin(lunches_admin)
        visit edit_user_registration_path(lunches_admin)
      end

      describe "it is lunches admin" do
        it { should have_content("YOU ARE THE LUNCHES ADMIN")}
        it { should have_link("Orders")}
        it { should have_link("Users")}
      end


      describe "page" do
        it { should have_content("Edit User") }
        it { should have_title("Edit User") }
      end

      describe "with invalid information" do
        before { click_button "Update" }

        it { should have_error_message('Please review the problems below:')  }
      end

      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        let(:new_password) { "123456" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: new_password
          fill_in "Password confirmation", with: new_password
          fill_in " Current password", with: lunches_admin.password
          click_button "Update"
        end


        it { should have_content(new_email) }
        it { should have_success_message( 'Your account has been updated successfully.') }      
        it { should have_link('Sign out', href: destroy_user_session_path) }
        specify { expect(lunches_admin.reload.name).to  eq new_name }
        specify { expect(lunches_admin.reload.email).to eq new_email }
        specify { expect(::BCrypt::Password.new("#{lunches_admin.reload.encrypted_password}") ).to eq new_password }
      end

      describe "cancel registration (delete lunches_admin)" do

        it { should have_link('Cancel my account') }

          it "should be able to cancel registration" do
            expect do
              click_link('Cancel my account')

            end.to change(User, :count).by(-1)

            should have_success_message( 'Bye! Your account has been successfully cancelled. We hope to see you again soon.')
            should have_link('Sign in')
            should have_link('Sign up')
            should_not have_link('Sign out')
          end
      end



    end

  end

end