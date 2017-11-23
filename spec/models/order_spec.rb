require 'rails_helper'

RSpec.describe Order, type: :model do

  let (:menu) { FactoryBot.create(:menu) }
  let (:user) { FactoryBot.create(:user) }
  let (:course_type) { CourseType.find_by_id(menu.course_type_id)}

  before do
    @order = Order.new(menu_id: menu.id,  
                     course_type_id: course_type.id,
                     user_id: user.id,
                     order_date: Date.today
                     )
  end

  subject { @order }

  it { should respond_to(:menu_id) }
  it { should respond_to(:menu) }
  it { should respond_to(:course_type_id) }
  it { should respond_to(:course_type) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:order_date) }

  it { expect(@order.course_type).to eq course_type }
  it { expect(@order.user).to eq user }


  it { should be_valid }


  describe "when menu_id is not present" do
    before { @order.menu_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @order.user_id = nil }
    it { should_not be_valid }
  end

  describe "when course_type_id is not present" do
    before { @order.course_type_id = nil }
    it { should_not be_valid }
  end

  describe "when course_type_id is not equal menu.course_type_id" do
    before { @order.course_type_id = FactoryBot.create(:course_type, name: 'new dessert').id }
    it { should_not be_valid }
  end


  describe "when order_date is not today" do
    it "should be invalid" do
      order_dates = [] << Date.yesterday << Date.tomorrow << 100.years.ago << 20.years.from_now 

      order_dates.each do |invalid_date|
        @order.order_date = invalid_date
        expect(@order).not_to be_valid
      end
    end
  end


end
