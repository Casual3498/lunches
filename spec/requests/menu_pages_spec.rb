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
            (Date.current.beginning_of_week(:monday)..Date.current.end_of_week(:monday)).each do |date|
              if (date <= Date.current) && #weekday
                (((1..5).include?(date.wday) && !add_holidays.include?(date.to_s)) || add_weekdays.include?(date.to_s)) 
                
                should have_link("#{date.day}", href: orders_path(order_date: date) ) 
              else #if date > Date.current or holiday
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

    describe "lunches admin can add items in menu only for today by adding a name and price" do
      before do
        Capybara.current_driver = :selenium  #set driver for work with js
        Capybara.default_max_wait_time = 1
        sign_in lunches_admin
        visit menus_path
      end
      after do
        Capybara.use_default_driver
      end

      it { should have_content('Menus') }
      it { should have_css("h1", text: /Menu on.*#{Date.current.strftime("%A")}.*#{Date.current.to_s}.*/i) } 
     
      shared_examples_for "add/delete/change menu items" do 
        specify do 
          within(:css, "tbody", id: "menu_index#{course_type.id}") do
            #menu for course is empty
            should_not have_css("tr", class: "menu_row")
            expect do
              5.times do |n|
                fill_in 'Name', with: "shchi №#{n}"
                fill_in 'Cost', with: "#{(rand()*1000).round(2)}"
                attach_file("menu[picture]", "#{Rails.root}/spec/support/images/#{n}.jpg")
                click_button "Create #{course_type.name.downcase} menu item", wait: 1
              end
            end.to change(Menu, :count).by(5) #check that items really added
            #menu for course must have 5 elements, that we just added
            should have_css("tr", class: "menu_row", count: 5)
            5.times do |n|
              should have_css("td", class: "name", text: "shchi №#{n}")
              should have_css("img[src$='thumb_#{n}.jpg']")
            end
          end
          #check, that items is appeared in order form
          click_link "#{Date.current.day}" 
          within(:css, "tbody", id: "order_index#{course_type.id}") do
            #menu for course must have 5 elements, that we just added
            should have_css("tr", class: "menu_row", count: 5)
            5.times do |n|
              should have_css("td", class: "name", text: "shchi №#{n}")
              should have_css("img[src$='thumb_#{n}.jpg']")
            end
          end
          #close modal form for order
          click_link "Cancel"

          #check deleting item
          #delete first item
          expect do
            within(:css, "tbody", id: "menu_index#{course_type.id}") do
              click_link_or_button 'Delete', match: :first
            end
            click_link_or_button 'Yes, Delete This Menu Item', wait: 1
          end.to change(Menu, :count).by(-1) #check that item really deleted
          #menu for course must have 4 elements, because first of 5 just was deleted
          within(:css, "tbody", id: "menu_index#{course_type.id}") do
            should have_css("tr", class: "menu_row", count: 4)
            #check that first item is deleted
            should_not have_css("td", class: "name", text: "shchi №0")
            should_not have_css("img[src$='thumb_0.jpg']")
          end
          #check, that items is disappeared in order form
          click_link "#{Date.current.day}" 
          within(:css, "tbody", id: "order_index#{course_type.id}") do
            #menu for course must have 4 elements, because 1 of 5 just was deleted
            should have_css("tr", class: "menu_row", count: 4)
          end
          #close modal form for order
          click_link "Cancel"

          #check updating image (As a Lunches Admin, I can upload photo for each menu item)
          #create item with no image
          within(:css, "tbody", id: "menu_index#{course_type.id}") do
            fill_in 'Name', with: "No image food"
            fill_in 'Cost', with: "199.98"
            click_button "Create #{course_type.name.downcase} menu item"
            #menu for course must have 5 elements, that we just added
            should have_css("tr", class: "menu_row", count: 5)
            should have_css("td", class: "name", text: "No image food")
            should have_css("td", class: "cost", text: "199.98")
            should have_css("img[src^='/assets/fallback/noimage'][src$='.gif']") 
            should have_css("img[alt='Noimage']")
            find(:css,"img[alt='Noimage']").click  
          end
          #set image
          within(:css, "form", id: "newmenu") do
            attach_file("menu[picture]", "#{Rails.root}/spec/support/images/0.jpg", visible: :all)
            click_button "Update Menu Item"
          end
          #check that image changes
          within(:css, "tbody", id: "menu_index#{course_type.id}") do
            should have_css("img[src$='thumb_0.jpg']")
            should_not have_css("img[src^='/assets/fallback/noimage'][src$='.gif']") 
            should_not have_css("img[alt='Noimage']")            
          end
        end
      end #shared_examples_for "add/delete/change menu items"

      shared_examples_for "could not add invalid menu items" do 
        specify do 
          within(:css, "tbody", id: "menu_index#{course_type.id}") do
            #menu for course is empty
            should_not have_css("tr", class: "menu_row")
           
            #fill with invalid cost 
            #examples with comma as decimal point not passed, because comma translate to dot (by browser?)
            #costs = %w[-12345678.99 100000000  -1 . 0.001 12,45 ,5 -0,6 -99,6 99999999.999 123.45.67 o O 1O]
            costs = %w[-12345678.99 100000000  -1 . 0.001  -0,6 -99,6 99999999.999 123.45.67 o O 1O]
            expect do
              costs.each_with_index do |cost, n|
                fill_in 'Name', with: "meat №#{n}"
                fill_in 'Cost', with: "#{cost}"
                click_button "Create #{course_type.name.downcase} menu item"
                #menu for course is still empty
                should_not have_css("tr", class: "menu_row")  
                should have_error_message /\AThe form contains.*error.+\z/    
              end
            end.to change(Menu, :count).by(0) #check that no item added

            #fill with dublicate name
            dublicate_name = "banana soup with milk no spicy"
            #add first item
            expect do
              fill_in 'Name', with: "banana soup with milk no spicy"
              fill_in 'Cost', with: "199.98"
              click_button "Create #{course_type.name.downcase} menu item"
            end.to change(Menu, :count).by(1) #check that item really added
            #menu for course has only item that just added
            should have_css("tr", class: "menu_row", count: 1)   
            should have_css("td", class: "name", text: "banana soup with milk no spicy")
            should have_css("td", class: "cost", text: "199.98")   
            should_not have_error_message /\AThe form contains.*error.+\z/                    
            #add second item
            expect do
              fill_in 'Name', with: "banana soup with milk no spicy"
              fill_in 'Cost', with: "45"
              click_button "Create #{course_type.name.downcase} menu item"
            end.to change(Menu, :count).by(0) #check that no item added
            #menu for course still has only 
            should have_error_message /\AThe form contains.*error.+\z/ 
            should have_css("tr", class: "menu_row", count: 1)   
            should have_css("td", class: "name", text: "banana soup with milk no spicy", count: 1)
            should_not have_css("td", class: "cost", text: "45")      

          end
        end
      end #shared_examples_for "could not add invalid menu items"

      it_behaves_like "could not add invalid menu items" do
        let!(:course_type) { course_type1 }
      end
      it_behaves_like "could not add invalid menu items" do
        let!(:course_type) { course_type2 }
      end
      it_behaves_like "could not add invalid menu items" do
        let!(:course_type) { course_type3 }
      end      

      it_behaves_like "add/delete/change menu items" do
        let!(:course_type) { course_type1 }
      end
      it_behaves_like "add/delete/change menu items" do
        let!(:course_type) { course_type2 }
      end
      it_behaves_like "add/delete/change menu items" do
        let!(:course_type) { course_type3 }
      end
    end

  end #describe "menus page" 



  shared_examples_for "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    let!(:menu_items) {[]}
    before do
      #create menu today
      5.times { menu_items << FactoryBot.create(:menu_fc) } 
      5.times { menu_items << FactoryBot.create(:menu_mc) } 
      5.times { menu_items << FactoryBot.create(:menu_dr) }
      #create menu on week ago 
      5.times { FactoryBot.create(:menu_fc_skips_validate, menu_date: 1.week.ago.to_date) } 
      5.times { FactoryBot.create(:menu_mc_skips_validate, menu_date: 1.week.ago.to_date) } 
      5.times { FactoryBot.create(:menu_dr_skips_validate, menu_date: 1.week.ago.to_date) } 
      #set driver for work with js
      Capybara.current_driver = :selenium
      sign_in user
      visit menus_path
    end
    after do
      Capybara.use_default_driver
    end
    it "show menu for today" do

      click_link "#{Date.current.day}"  #in application.rb we add today as weekday 
      within('#order-modal') do
        should have_content("Order on #{Date.current.to_s}") 
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
      click_link "#{(1.week.ago.to_date).day}"  #in application.rb we add day week ago as weekday 

      within('#order-modal') do

        should have_content("Order on #{(1.week.ago.to_date).to_s}") 
        should have_css("tr", class: "menu_row", count: 15)
        should have_css("td", class: "name", text: "#{course_type1.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type2.name} menu item", count: 5)
        should have_css("td", class: "name", text: "#{course_type3.name} menu item", count: 5)
        should have_css("td", class: "cost", count: 15, text: /\A\d{8}\.\d{2}\z/i)

        click_link "Close"
      end
    end  

    it "user can only choose not more than 1 item of each course type and press Submit" do
      click_link "#{Date.current.day}"
      should have_button("Submit") 

      #choose all items one by one
      menu_items.each do |menuitem|
        choose("menu_id_#{menuitem.id}")
      end
      # #now we have chosen last items in menu of each course types 
      # #return and choose first drink
      menu_items.reverse.take(5).each do |menuitem|
        choose("menu_id_#{menuitem.id}")
      end

      #check that only one of each course type chosen 
      chosen = [4,9,10] #we chose last(fifth) first course, last(fifth) main course, and first drink
      menu_items.each_with_index do |menuitem, indexitem|
        if chosen.include?(indexitem) 
          expect(find_by_id("menu_id_#{menuitem.id}")).to be_checked
          case indexitem
            when chosen.first
              expect(menuitem.course_type).to eq(course_type1)
            when chosen.second
              expect(menuitem.course_type).to eq(course_type2)
            when chosen.third
              expect(menuitem.course_type).to eq(course_type3)                            
          end
        else
          expect(find_by_id("menu_id_#{menuitem.id}")).not_to be_checked
        end  
      end

      # should have_button("Submit") 
      click_button("Submit") #make the order
      #reopen menu and order modal window
      click_link "#{Date.current.day}"
      should_not have_button("Submit") #we already make the order
      #choose all items disabled (visible for capybara) 
      menu_items.each_with_index do |menuitem, indexitem|
        expect(find_by_id("menu_id_#{menuitem.id}", visible: :all)).not_to be_visible
        #check that chosen menu items still checked
        if chosen.include?(indexitem) 
          expect(find_by_id("menu_id_#{menuitem.id}", visible: :all)).to be_checked
        case indexitem
          when chosen.first
            expect(menuitem.course_type).to eq(course_type1)
          when chosen.second
            expect(menuitem.course_type).to eq(course_type2)
          when chosen.third
            expect(menuitem.course_type).to eq(course_type3)                            
        end
        else
          expect(find_by_id("menu_id_#{menuitem.id}", visible: :all)).not_to be_checked
        end  
      end
      #check, that chosen menu_items on first place in their tables (not worked) 
      # within(:css, "#order_index#{course_type1.id}", visible: :all) do
      #   all(:css, "td", class: "checked", visible: :all).each_with_index do |elem, i|
      #     pp "#{i} elem.checked? = " << elem.checked?.to_s
      #     pp "#{i} elem.visible? = " << elem.visible?.to_s
      #     pp "#{i} elem.selected? = " << elem.selected?.to_s
      #     pp "#{i} elem.disabled? = " << elem.disabled?.to_s
      #     pp "#{i} elem.readonly? = " << elem.readonly?.to_s
      #     pp "#{i} elem.text = " << elem.text.to_s          
      #     pp "#{i} elem.value = " << elem.value.to_s
      #     pp "#{i} elem = " << elem.to_s
      #     pp "-------------------------------------"
      #   end
        # expect(first(:css, "td", class: "checked", visible: :all)).to be_checked
      # end
    end
  end #shared_examples_for "when user click on the weekday

  it_behaves_like "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    let!(:user) { ordinary_user }
  end
  it_behaves_like "when user click on the weekday(today or days in the past), he can see menu ­list of items with prices" do
    let!(:user) { lunches_admin }
  end
 
end