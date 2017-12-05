require 'rails_helper'

RSpec.describe "OrderPages", type: :request do
  let!(:add_holidays) { Rails.configuration.holidays }
  let!(:add_weekdays) { Rails.configuration.weekdays }
  let!(:lunches_admin) { FactoryBot.create(:user) }
  let!(:ordinary_user) { FactoryBot.create(:user) }
  #create menu today 
  let!(:menu_fc) { FactoryBot.create(:menu_fc) } 
  let!(:menu_mc) { FactoryBot.create(:menu_mc) }
  let!(:menu_dr) { FactoryBot.create(:menu_dr) }
    #create menu on week ago 
  let!(:menu_fc_old) { FactoryBot.create(:menu_fc_skips_validate, menu_date: 1.week.ago.to_date ) } 
  let!(:menu_mc_old) { FactoryBot.create(:menu_mc_skips_validate, menu_date: 1.week.ago.to_date) } 
  let!(:menu_dr_old) { FactoryBot.create(:menu_dr_skips_validate, menu_date: 1.week.ago.to_date) } 
  before do
    #create today orders
    #for ordinary user
    FactoryBot.create(:order, user: ordinary_user, menu: menu_fc, course_type: menu_fc.course_type)
    FactoryBot.create(:order, user: ordinary_user, menu: menu_mc, course_type: menu_mc.course_type)
    FactoryBot.create(:order, user: ordinary_user, menu: menu_dr, course_type: menu_dr.course_type)
    #for lunches admin
    FactoryBot.create(:order, user: lunches_admin, menu: menu_fc, course_type: menu_fc.course_type)
    FactoryBot.create(:order, user: lunches_admin, menu: menu_mc, course_type: menu_mc.course_type)
    FactoryBot.create(:order, user: lunches_admin, menu: menu_dr, course_type: menu_dr.course_type) 
    #create old (week ago) orders
    #for ordinary user
    FactoryBot.create(:order_skips_validate, user: ordinary_user, menu: menu_fc_old, course_type: menu_fc_old.course_type, order_date: 1.week.ago.to_date)
    FactoryBot.create(:order_skips_validate, user: ordinary_user, menu: menu_mc_old, course_type: menu_mc_old.course_type, order_date: 1.week.ago.to_date)
    FactoryBot.create(:order_skips_validate, user: ordinary_user, menu: menu_dr_old, course_type: menu_dr_old.course_type, order_date: 1.week.ago.to_date)
    #for lunches admin
    FactoryBot.create(:order_skips_validate, user: lunches_admin, menu: menu_fc_old, course_type: menu_fc_old.course_type, order_date: 1.week.ago.to_date)
    FactoryBot.create(:order_skips_validate, user: lunches_admin, menu: menu_mc_old, course_type: menu_mc_old.course_type, order_date: 1.week.ago.to_date)
    FactoryBot.create(:order_skips_validate, user: lunches_admin, menu: menu_dr_old, course_type: menu_dr_old.course_type, order_date: 1.week.ago.to_date)        
  end
  subject { page }

  describe "orders page" do

    describe "unsigned user not allowed to see Orders page" do
      before { visit orders_path }

      it_behaves_like "must contain data in content and title" do
        let!(:data) { 'Sign in' }
      end
      it { should have_error_message('You need to sign in or sign up before continuing.') }
    end

    describe "ordinary user can not see Orders page and must be redirected on root path" do
      before do
        sign_in ordinary_user
        visit all_orders_path
      end

      it { should have_error_message('You not allowed to see all orders.') }

      it { expect(current_path).to eq root_path }
    end

    describe "lunches admin can see Orders page" do
      before do
        sign_in lunches_admin
        visit all_orders_path
      end


      it { should have_content('Orders') }

      days_of_the_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
      days_of_the_week.each do |day_name|
        it { should have_content(day_name) }
      end

      describe "weekdays table" do

        it "exists" do
          expect(page).to have_css 'table', class: "calendar"
        end  

        specify "lunches admin can click on the weekday (today or days in the past)" do
          within "table", class: "calendar" do
            (Date.current.beginning_of_week(:monday)..Date.current.end_of_week(:monday)).each do |date|
              if (date <= Date.current) && #weekday
                (((1..5).include?(date.wday) && !add_holidays.include?(date.to_s)) || add_weekdays.include?(date.to_s)) 
                
                should have_link("#{date.day}", href: all_orders_path(order_date: date) ) 
              else #if date > Date.current or holiday
                should have_content("#{date.day}")
                should_not have_link( href: all_orders_path(order_date: date) )
              end
            end

            should have_css 'th', class: "weekdays" ##in application.rb we add today as weekday, otherwise this test would be not be passed, for example, after being launched during the Christmas and New Year period 
            should have_css 'th', class: "holidays"
            should have_css 'th', class: "today"
          end
        end
      end


      describe "lunches admin can see all orders for today" do

        specify "check today orders" do

          should have_css("h1", text: /Orders on.*#{Date.current.strftime("%A")}.*#{Date.current.to_s}.*/i)
          #we add 6 order items - 3 for lunches admin and 3 for ordinary user
          within(:css, "div", id: "orders") do
            should have_css("tr", class: "order_row", count: 6)
            #check that each item exists 2 times
            should have_css("td", class: "name", text: "#{menu_fc.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_mc.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_dr.name}", count: 2)
            #check thet each user exists once
            should have_css("td", class: "user_name", text: "#{ordinary_user.name}", count: 1)
            should have_css("td", class: "user_name", text: "#{lunches_admin.name}", count: 1)
            #check sum
            within(:css, "tr", class: "sum_row") do
              sum = ((menu_fc.cost+menu_mc.cost+menu_dr.cost)*2).to_s
              should have_css("td", class: "all_sum", text: "#{sum}")
            end
          end
        end
      end
    end

    describe "lunches admin can browse days and see users’ orders there" do
      before do
        Capybara.current_driver = :selenium
        sign_in lunches_admin
        visit all_orders_path
      end
      after do
        Capybara.use_default_driver
      end

      specify "open today orders in modal window" do
        click_link "#{Date.current.day}", visible: :all  #in application.rb we add today as weekday 
        #save_and_open_page
        within('#all-order-modal') do
         #we add 6 order items - 3 for lunches admin and 3 for ordinary user
          within(:css, "div", id: "orders") do
            should have_css("tr", class: "order_row", count: 6)
            #check that each item exists 2 times
            should have_css("td", class: "name", text: "#{menu_fc.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_mc.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_dr.name}", count: 2)
            #check thet each user exists once
            should have_css("td", class: "user_name", text: "#{ordinary_user.name}", count: 1)
            should have_css("td", class: "user_name", text: "#{lunches_admin.name}", count: 1)
            #check sum
            within(:css, "tr", class: "sum_row") do
              sum = ((menu_fc_old.cost+menu_mc_old.cost+menu_dr_old.cost)*2).to_s
              should have_css("td", class: "all_sum", text: "#{sum}")
            end
          end
        end
      end

      specify "open week ago orders in modal window" do
        find(".fa-angle-double-left").click #go to last week
        click_link "#{1.week.ago.day}", visible: :all  #in application.rb we add today as weekday 
        within('#all-order-modal') do
          should have_css("h1", text: /Orders on.*#{(1.week.ago.to_date).strftime("%A")}.*#{(1.week.ago.to_date).to_s}.*/i)
          #we add 6 order items - 3 for lunches admin and 3 for ordinary user
          within(:css, "div", id: "orders") do
            should have_css("tr", class: "order_row", count: 6)
            #check that each item exists 2 times
            should have_css("td", class: "name", text: "#{menu_fc_old.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_mc_old.name}", count: 2)
            should have_css("td", class: "name", text: "#{menu_dr_old.name}", count: 2)
            #check thet each user exists once
            should have_css("td", class: "user_name", text: "#{ordinary_user.name}", count: 1)
            should have_css("td", class: "user_name", text: "#{lunches_admin.name}", count: 1)
            #check sum
            within(:css, "tr", class: "sum_row") do
              sum = ((menu_fc.cost+menu_mc.cost+menu_dr.cost)*2).to_s
              should have_css("td", class: "all_sum", text: "#{sum}")
            end
          end
        end
      end      

    end


  end
end
