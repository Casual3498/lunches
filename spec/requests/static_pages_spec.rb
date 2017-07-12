require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  # describe "GET /static_pages" do
  #   it "works! (now write some real specs)" do
  #     get static_pages_index_path
  #     expect(response).to have_http_status(200)
  #   end
  # end
  describe "Dashboard page" do
  	it "should have the content dashboard" do
  		visit 'static_pages/dashboard'
  		expect(page).to have_content('Dashboard')
  	end
  

    it "should have the title 'Dashboard'" do
      visit '/static_pages/dashboard'
      expect(page).to have_title("Lunches | Dashboard")
    end
  end
end
