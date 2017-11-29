require 'rails_helper'




RSpec.describe "MenuPages", type: :request do
  
  let!(:add_holidays) { Rails.configuration.holidays }
  let!(:add_weekdays) { Rails.configuration.weekdays }
  let!(:lunches_admin) { FactoryBot.create(:user) }
  let!(:ordinary_user) { FactoryBot.create(:user) } 

  subject { page }


  describe "menus page" do

    describe "unsigned user not allowed to see Menus page" do
      before { visit menus_path }

      it_behaves_like "must contain data in content and title" do
        let!(:data) { 'Sign in' }
      end
      it { should have_error_message('You need to sign in or sign up before continuing.') }
    end


    shared_examples_for "user must see weekdays" do
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
          within "table", class: "calendar" do
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
    end #shared_examples_for

    it_behaves_like "user must see weekdays" do
      let!(:user) { ordinary_user }
    end
    it_behaves_like "user must see weekdays" do
      let!(:user) { lunches_admin }
    end
  end #describe "menus page" 

  shared_examples_for "day menu page" do
    before do
      Capybara.current_driver = :selenium
      sign_in user
      visit menus_path
      # @request.env['HTTP_ACCEPT'] = "text/javascript"
      click_link "#{Date.today.day}"  #this test not be passed in holiday  
    end
    after do
      Capybara.use_default_driver
    end
    it "show menu for day" do
      within('#order-modal') do

        should have_content("Order on #{Date.today.to_s}") # async
      end
      # it { should have_content("Order on #{Date.today.to_s}") } 
    end
  end

  it_behaves_like "day menu page" do
    let!(:user) { ordinary_user }
  end
  # it_behaves_like "day menu page" do
  #   let!(:user) { lunches_admin }
  # end

 
end

