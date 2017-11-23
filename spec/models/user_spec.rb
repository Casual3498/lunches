require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = User.new(name: "Example User", email: "user@example.com", 
    password: "123456", password_confirmation: "123456") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) } 
  it { should respond_to(:valid_password?)}
  it { should respond_to(:rememberable_value)}
  it { should respond_to(:remember_me)}
  it { should respond_to(:remember_me!)}
  it { should respond_to(:remember_me?)} 
  it { should respond_to(:forget_me!)}
  it { should respond_to(:authentication_token) }
  it { should respond_to(:is_lunches_admin?)}


  it { should be_valid }
  it { should_not be_is_lunches_admin }



  describe "with saving first user becomes the lunches admin" do
    before { @user.save }

    it { should be_is_lunches_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end



  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end  

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user@..com user@foo..ru]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn Foo@ExAMPle.CoM]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end



  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end



  describe "when password is not present" do
    before { @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ") }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end  


  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_for_database_authentication(email: @user.email) }

    describe "with valid password" do
      it { expect(found_user.valid_password?(@user.password)).to be_truthy  }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.valid_password?("invalid") ? found_user : nil }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end


 describe "with a password that's too long" do
    before { @user.password = @user.password_confirmation = "a" * 129 }
    it { should be_invalid }
  end




  describe "authentication token" do
    before { @user.save }

    it { expect(@user.authentication_token).not_to be_blank }
  end







  # RSpec.configure do |config|
  #   config.include Devise::Test::ControllerHelpers, type: :controller
  #   config.include Devise::Test::ControllerHelpers, type: :view
  # end





end
