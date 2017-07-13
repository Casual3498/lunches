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
      expect(page).to have_title("#{base_title} | Dashboard")
    end
  end

  describe "Dashboard Lunches Admin page" do
  	it "should have the content Dashboard Lunches Admin" do
  		visit 'static_pages/dashboard_lunches_admin'
  		expect(page).to have_content('Dashboard Lunches Admin')
  	end
  

    it "should have the title 'Dashboard Lunches Admin'" do
      visit '/static_pages/dashboard_lunches_admin'
      expect(page).to have_title("#{base_title} | Dashboard Lunches Admin")
    end
  end


end
