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
                     order_date: Date.current
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
                 order_date: Date.current
                 )
      @order_fc.save! #save first course menu example
    end
    it { expect(@order_example).not_to be_valid }
  end

  describe "when course_type is first course, main course or drink" do
    before do
      @orders = (Order.where('order_date = :order_date and user_id = :user_id', 
                      { order_date: Date.current, user_id: user.id })) 
      @order_mc = Order.new(menu: menu_mc,  
                 course_type: menu_mc.course_type,
                 user: user,
                 order_date: Date.current
                 )
      @order_dr = Order.new(menu: menu_dr,  
                 course_type: menu_dr.course_type,
                 user: user,
                 order_date: Date.current
                 )
      @order_fc.save! #save first course menu example
    end

    it { expect(@orders.count).to equal(1) } #have first course in order

    it { expect(@order_mc).to be_valid }
    it { expect(@order_dr).to be_valid }


    describe "only one item each course type allow for one user" do
      before do
        menu_fc_new = FactoryBot.create(:menu_fc)
        @order_fc_new = Order.new(menu: menu_fc_new,  
               course_type: menu_fc_new.course_type,
               user: user,
               order_date: Date.current
               )
        menu_mc_new = FactoryBot.create(:menu_mc)
        @order_mc_new = Order.new(menu: menu_mc_new,  
               course_type: menu_mc_new.course_type,
               user: user,
               order_date: Date.current
               )
        menu_dr_new = FactoryBot.create(:menu_dr)
        @order_dr_new = Order.new(menu: menu_dr_new,  
               course_type: menu_dr_new.course_type,
               user: user,
               order_date: Date.current
               )        
      end

      it { expect(@orders.count).to equal(1) } #have first course in order

      it { expect(@order_mc).to be_valid }
      it { expect(@order_dr).to be_valid }
      it { expect(@order_fc_new).not_to be_valid }
      it { expect(@order_mc_new).to be_valid }
      it { expect(@order_dr_new).to be_valid }

      specify  do 
        @order_dr.save!      #save drink menu example

        expect(@orders.count).to equal(2)  #have first course and drink in order

        expect(@order_mc).to be_valid 
        expect(@order_fc_new).not_to be_valid 
        expect(@order_mc_new).to be_valid 
        expect(@order_dr_new).not_to be_valid
      end

      specify  do 
        @order_dr.save!      #save drink menu example
        @order_mc.save!      #save main course menu example

        expect(@orders.count).to equal(3)  #have first course main course and drink in order

        expect(@order_fc_new).not_to be_valid 
        expect(@order_mc_new).not_to be_valid 
        expect(@order_dr_new).not_to be_valid
      end

      specify do
        @order_mc_new.save! #save new main course menu example

        expect(@orders.count).to equal(2)  #have first course and main_course in order

        expect(@order_dr).to be_valid 
        expect(@order_mc).not_to be_valid 
        expect(@order_fc_new).not_to be_valid 
        expect(@order_dr_new).to be_valid   
      end

      specify do
        @order_mc_new.save! #save new main course menu example
        @order_dr_new.save! #save new drink menu example

        expect(@orders.count).to equal(3)  #have first course main course and drink in order
        
        expect(@order_dr).not_to be_valid 
        expect(@order_mc).not_to be_valid 
        expect(@order_fc_new).not_to be_valid    
      end
    end
  end



  describe "when order_date is not today" do
    it "should be invalid" do
      order_dates = [] << (Date.current-1.day) << (Date.current+1.day) << 100.years.ago << 20.years.from_now 

      order_dates.each do |invalid_date|
        @order_fc.order_date = invalid_date
        expect(@order_fc).not_to be_valid
      end
    end
  end

  # describe "order on same date can contain only one item of each course type: first course, main course and drink" do

 



  # end


end
