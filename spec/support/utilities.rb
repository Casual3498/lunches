include ApplicationHelper


def valid_signin(user, options={})

  if options[:no_capybara]
    sign_in user
    get root_path
    expect(controller.current_user).to eq(user)
        
  else
    fill_in "Email",    with: user.email.upcase
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end



def fill_valid_signup
  fill_in "Name", with: "Example User"
  fill_in "Email",with: "name@example.com"
  fill_in "Password", with: "123456", :match => :prefer_exact 
  fill_in "Password confirmation", with: "123456", :match => :prefer_exact
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('.alert.alert-danger', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('p.alert.alert-success', text: message)
  end
end