require 'rails_helper'

RSpec.describe Order, type: :model do

  let! (:menu_fc) { FactoryBot.create(:menu_fc) }
  let! (:menu_mc) { FactoryBot.create(:menu_mc) }
  let! (:menu_dr) { FactoryBot.create(:menu_dr) }
  let! (:user) { FactoryBot.create(:user) }

  before do
    @order_fc = Order.new(menu: menu_fc,  
                     course_type: menu_fc.course_type,
                     user: user,
                     order_date: Date.today
                     )
  end

  subject { @order_fc }

  it { should respond_to(:menu_id) }
  it { should respond_to(:menu) }
  it { should respond_to(:course_type_id) }
  it { should respond_to(:course_type) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:order_date) }

  it { expect(@order_fc.course_type).to eq menu_fc.course_type }
  it { expect(@order_fc.user).to eq user }


  it { should be_valid }


  describe "when menu_id is not present" do
    before { @order_fc.menu_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @order_fc.user_id = nil }
    it { should_not be_valid }
  end

  describe "when course_type_id is not present" do
    before { @order_fc.course_type_id = nil }
    it { should_not be_valid }
  end

  describe "when course_type is not equal menu.course_type" do

    before { @order_fc.course_type = menu_mc.course_type }

    it { should_not be_valid }
  end

  describe "when course_type is not first course, main course or drink" do
    # let! (:menu_example) { FactoryBot.create(:menu) } #item with invalid (unpermitted) course type 
    # let! (:menu_mc) { FactoryBot.create(:menu_mc) }
    # let! (:menu_dr) { FactoryBot.create(:menu_dr) }    
    before do
      menu_example = FactoryBot.create(:menu)  #item with invalid (unpermitted) course type
      @order_example = Order.new(menu: menu_example,  
                 course_type: menu_example.course_type,
                 user: user,
                 order_date: Date.today
                 )
      @order_fc.save! #save first course menu example
    end
    it { expect(@order_example).not_to be_valid }
  end

  describe "when course_type is first course, main course or drink" do
    before do
      @order_mc = Order.new(menu: menu_mc,  
                 course_type: menu_mc.course_type,
                 user: user,
                 order_date: Date.today
                 )
      @order_dr = Order.new(menu: menu_dr,  
                 course_type: menu_dr.course_type,
                 user: user,
                 order_date: Date.today
                 )
      @order_fc.save! #save first course menu example
    end

    it { expect(@order_mc).to be_valid }
    it { expect(@order_dr).to be_valid }


    describe "only one item each course type allow for one user" do
      before do
        menu_fc_new = FactoryBot.create(:menu_fc)
        @order_fc_new = Order.new(menu: menu_fc_new,  
               course_type: menu_fc_new.course_type,
               user: user,
               order_date: Date.today
               )
        menu_mc_new = FactoryBot.create(:menu_mc)
        @order_mc_new = Order.new(menu: menu_mc_new,  
               course_type: menu_mc_new.course_type,
               user: user,
               order_date: Date.today
               )
        menu_dr_new = FactoryBot.create(:menu_dr)
        @order_dr_new = Order.new(menu: menu_dr_new,  
               course_type: menu_dr_new.course_type,
               user: user,
               order_date: Date.today
               )        
      end

      it { expect(@order_mc).to be_valid }
      it { expect(@order_dr).to be_valid }
      it { expect(@order_fc_new).not_to be_valid }
      it { expect(@order_mc_new).to be_valid }
      it { expect(@order_dr_new).to be_valid }

      specify  do 
        @order_dr.save!      #save drink menu example

        expect(@order_mc).to be_valid 
        expect(@order_fc_new).not_to be_valid 
        expect(@order_mc_new).to be_valid 
        expect(@order_dr_new).not_to be_valid
      end

      specify  do 
        @order_dr.save!      #save drink menu example
        @order_mc.save!      #save main course menu example

        expect(@order_fc_new).not_to be_valid 
        expect(@order_mc_new).not_to be_valid 
        expect(@order_dr_new).not_to be_valid
      end

      specify do
        @order_mc_new.save! #save new main course menu example

        expect(@order_dr).to be_valid 
        expect(@order_mc).not_to be_valid 
        expect(@order_fc_new).not_to be_valid 
        expect(@order_dr_new).to be_valid   
      end

      specify do
        @order_mc_new.save! #save new main course menu example
        @order_dr_new.save! #save new drink menu example
        
        expect(@order_dr).not_to be_valid 
        expect(@order_mc).not_to be_valid 
        expect(@order_fc_new).not_to be_valid    
      end


    end


  end

    # describe "main course be valid" do
    #   before do 
    #     @order_mc = Order.new(menu: menu_mc,  
    #            course_type: menu_mc.course_type,
    #            user: user,
    #            order_date: Date.today
    #            )
    #   end
    #   it { expect(@order_mc).to be_valid }

    #   describe "drink be valid" do
    #     before do 
    #       @order_dr = Order.new(menu: menu_dr,  
    #              course_type: menu_dr.course_type,
    #              user: user,
    #              order_date: Date.today
    #              )
    #       @order_mc.save! #save main_course menu example
    #     end
    #     it { expect(@order_dr).to be_valid }

    #     describe "can be next items in order: 'first course', 'main course', 'drink' and only they" do
    #       before do 
    #         @order_dr.save! #save drink menu example
    #         @orders = (Order.where('order_date = :order_date and user_id = :user_id', { order_date: Date.today, user_id: user.id })) 

    #       end

          # specify "check that order may contain 3 items: 'first course', 'main course', 'drink' " do
          #   course_types = Rails.configuration.valid_course_type_values.map(&:downcase)

          #   @orders.each do |order|
          #     it { expect(course_types.include?(order.course_type.name.downcase)).to be_truthy  }
          #   end

          #   it { expect(@orders.count).to equal(course_types.count)}
          # end

          # specify "check that order can not contain other items with course types: 'first course', 'main course', 'drink' " do


          #     menu_fc_new = FactoryBot.create(:menu_fc)
          #     menu_mc_new = FactoryBot.create(:menu_mc) 
          #     menu_dr_new = FactoryBot.create(:menu_dr) 

          #     @order_fc_new = Order.new(menu: menu_fc_new,  
          #            course_type: menu_fc_new.course_type,
          #            user: user,
          #            order_date: Date.today
          #            )
          #     @order_mc_new = Order.new(menu: menu_mc_new,  
          #            course_type: menu_mc_new.course_type,
          #            user: user,
          #            order_date: Date.today
          #            )
          #     @order_dr_new = Order.new(menu: menu_dr,  
          #            course_type: menu_dr.course_type,
          #            user: user,
          #            order_date: Date.today
          #            )       

          #     # it { expect(@order_fc_new).not_to be_valid }
          #     # it { expect(@order_mc_new).not_to be_valid }
          #     # it { expect(@order_dr_new).not_to be_valid }

          # end

        # end

    #   end
    # end


  # end


  describe "when order_date is not today" do
    it "should be invalid" do
      order_dates = [] << Date.yesterday << Date.tomorrow << 100.years.ago << 20.years.from_now 

      order_dates.each do |invalid_date|
        @order_fc.order_date = invalid_date
        expect(@order_fc).not_to be_valid
      end
    end
  end

  # describe "order on same date can contain only one item of each course type: first course, main course and drink" do

 



  # end


end
