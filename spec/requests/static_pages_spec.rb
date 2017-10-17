require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

 let(:base_title) { "Lunches" }

  describe "Privacy Notice page" do
  	it "should have the content Privacy Policy" do
  		visit 'privacy_notice'
  		expect(page).to have_content('Privacy Policy')
  	end
  

    it "should have the title 'Privacy Notice'" do
      visit 'privacy_notice'
      expect(page).to have_title("#{base_title} | Privacy Notice")
    end
  end

  describe "Conditions of Use page" do
  	it "should have the content Terms of Use" do
  		visit 'conditions_of_use'
  		expect(page).to have_content('Terms of Use')
  	end
  

    it "should have the title 'Conditions of Use'" do
      visit 'conditions_of_use'
      expect(page).to have_title("#{base_title} | Conditions of Use")
    end
  end


end
