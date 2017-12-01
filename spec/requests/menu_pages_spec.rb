require 'rails_helper'




RSpec.describe "MenuPages", type: :request do
  
  let!(:add_holidays) { Rails.configuration.holidays }
  let!(:add_weekdays) { Rails.configuration.weekdays }
  let!(:lunches_admin) { FactoryBot.create(:user) }
  let!(:ordinary_user) { FactoryBot.create(:user) } 
  let!(:course_type1) { Rails.configuration.valid_course_type_values.is_a?(Array) ? 
                  CourseType.where('lower(name) = ?',Rails.configuration.valid_course_type_values.map(&:downcase).first).first
                  : CourseType.first }
  let!(:course_type2) { Rails.configuration.valid_course_type_values.is_a?(Array) ? 
                  CourseType.where('lower(name) = ?',Rails.configuration.valid_course_type_values.map(&:downcase).second).first
                  : CourseType.second }
  let!(:course_type3) { Rails.configuration.valid_course_type_values.is_a?(Array) ? 
                  CourseType.where('lower(name) = ?',Rails.configuration.valid_course_type_values.map(&:downcase).third).first
                  : CourseType.third }



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

            should have_css 'th', class: "weekdays" ##in application.rb we add today as weekday, otherwise this test would be not be passed, for example, after being launched during the Christmas and New Year period 
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

  shared_examples_for "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    before do
      #create menu today
      5.times { FactoryBot.create(:menu_fc) } 
      5.times { FactoryBot.create(:menu_mc) } 
      5.times { FactoryBot.create(:menu_dr) }
      #create menu on week ago 
      5.times { FactoryBot.create(:menu_fc_skips_validate, menu_date: Date.today-7.days) } 
      5.times { FactoryBot.create(:menu_mc_skips_validate, menu_date: Date.today-7.days) } 
      5.times { FactoryBot.create(:menu_dr_skips_validate, menu_date: Date.today-7.days) } 
      #set driver for work with js
      Capybara.current_driver = :selenium
      sign_in user
      visit menus_path
    end
    after do
      Capybara.use_default_driver
    end
    it "show menu for today" do

      click_link "#{Date.today.day}"  #in application.rb we add today as weekday 
      within('#order-modal') do
        should have_content("Order on #{Date.today.to_s}") 
        should have_css("tr", class: "menu_row", count: 15)
        should have_css("td", class: "name", text: "#{course_type1.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type2.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type3.name} menu item", count: 5)
        should have_css("td", class: "cost", count: 15, text: /\A\d{8}\.\d{2}\z/i)
        click_link "Cancel"
      end
    end


    it "show menu for day week ago" do

      find(".fa-angle-double-left").click #go to last week
      click_link "#{(Date.today-7.days).day}"  #in application.rb we add day week ago as weekday 

      within('#order-modal') do

        should have_content("Order on #{(Date.today-7.days).to_s}") 

        should have_css("tr", class: "menu_row", count: 15)
        should have_css("td", class: "name", text: "#{course_type1.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type2.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type3.name} menu item", count: 5)
        should have_css("td", class: "cost", count: 15, text: /\A\d{8}\.\d{2}\z/i)

        click_link "Close"
      end
    end    
  end

  it_behaves_like "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    let!(:user) { ordinary_user }
  end
  it_behaves_like "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    let!(:user) { lunches_admin }
  end

 
end

