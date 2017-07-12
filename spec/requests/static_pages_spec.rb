require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

 let(:base_title) { "Lunches" }

  describe "Dashboard page" do
  	it "should have the content dashboard" do
  		visit 'static_pages/dashboard'
  		expect(page).to have_content('Dashboard')
  	end
  

    it "should have the title 'Dashboard'" do
      visit '/static_pages/dashboard'
      expect(page).to have_title("#{:base_title} | Dashboard")
    end
  end
end
