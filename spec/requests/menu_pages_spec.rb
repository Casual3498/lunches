require 'rails_helper'




RSpec.describe "MenuPages", type: :request do
  
  let(:base_title) { "Lunches" }
  let!(:add_holidays) { Rails.configuration.holidays }
  let!(:add_weekdays) { Rails.configuration.weekdays }


  subject { page }


  shared_examples_for "titled" do
    it "has the right title" do
      #expect(response).to 
      #should have_title( "#{base_title} | Sign in")
      #expect(response).to  have_css 'title', text: "#{base_title}", visible: false
      should have_title ("#{base_title} | Sign in")
      #expect(page).to have_selector("title", text: "Sign in", visible: false)
    end
  end


  describe "menus page" do
    let!(:lunches_admin) { FactoryBot.create(:user) }
    let!(:user) { FactoryBot.create(:user) } 





    describe "unsigned user not allowed to see Menus page" do
      before { visit menus_path }

it_should_behave_like "titled"

      it { should have_content('Sign in') }    
      it { should have_title ("#{base_title} | Sign in") }
      it { should have_error_message('You need to sign in or sign up before continuing.') }
    end


    describe "user must see weekdays" do
      before do
        sign_in user
        visit menus_path
      end

      it { should have_content('Menus') }

      days_of_the_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
      days_of_the_week.each do |day_name|
        it { should have_content(day_name) }
      end

      describe "weekdays table" do

        it "exists" do
          expect(page).to have_css 'table', class: "calendar"
        end  

        specify "user can click on the weekday (today or days in the past)" do
          within "table" do
            (Date.today.beginning_of_week(:monday)..Date.today.end_of_week(:monday)).each do |date|
              if (date <= Date.today) && #weekday
                (((1..5).include?(date.wday) && !add_holidays.include?(date.to_s)) || add_weekdays.include?(date.to_s)) 
                
                should have_link("#{date.day}", href: orders_path(order_date: date) ) 
              else #if date > Date.today or holiday
                should have_content("#{date.day}")
                should_not have_link( href: orders_path(order_date: date) )
              end
            end

            should have_css 'th', class: "weekdays" #this test may not be passed, for example, after being launched during the Christmas and New Year period 
            should have_css 'th', class: "holidays"
            should have_css 'th', class: "today"
          end
        end

      end  
   #---------------------------------------------------------------------
      describe "same test for lunches admin" do
        before do   
          sign_out user
          sign_in lunches_admin
          visit menus_path
        end
      end

    end




  end

 
end