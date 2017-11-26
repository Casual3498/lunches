require 'rails_helper'

RSpec.describe Menu, type: :model do



  let! (:course_type) {FactoryBot.create(:course_type) }
  let! (:currency_type) {FactoryBot.create(:currency_type) }

  before do
    @menu = Menu.new(name: "Borsch", 
                     cost: "98.99", 
                     course_type_id: course_type.id,
                     currency_type_id: currency_type.id,
                     picture: "www.example.com/img/picture.jpg",
                     menu_date: Date.today
                     )
  end

  subject { @menu }

  it { should respond_to(:name) }
  it { should respond_to(:cost) }
  it { should respond_to(:course_type_id) }
  it { should respond_to(:course_type) }
  it { should respond_to(:currency_type_id) }
  it { should respond_to(:currency_type) }
  it { should respond_to(:picture) }
  it { should respond_to(:menu_date) }

  it { expect(@menu.course_type).to eq course_type }
  it { expect(@menu.currency_type).to eq currency_type }


  it { should be_valid }


  describe "when name is not present" do
    before { @menu.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @menu.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is not unique with same course type (on same date)" do
    before do
      menu_with_same_name = @menu.dup
      menu_with_same_name.name.upcase!
      menu_with_same_name.cost = menu_with_same_name.cost.to_s #scientific notation do not pass format validation
      menu_with_same_name.save!
    end

    it { should_not be_valid }

    describe "must be valid when course type is other" do
      before { @menu.course_type = FactoryBot.create(:course_type, name: "Other course type") }
      
      it { should be_valid }
    end

  end

  describe "when cost is not present" do
    before { @menu.cost = " " }
    it { should_not be_valid }
  end

  describe "when cost format is invalid (not positive digit 8.2)" do
    it "should be invalid" do
      costs = %w[-12345678.99 100000000  -1 . 0.001 12,45 ,5 -0,6 -99,6 99999999.999 123.45.67 o O 1O]
      costs.each do |invalid_cost|
        @menu.cost = invalid_cost
        expect(@menu).not_to be_valid
      end
    end
  end

  describe "when cost format is valid" do
    it "should be valid" do
      costs = %w[0 12345678.99 .0 .55 154 0.01 99999999.99]
      costs.each do |valid_cost|
        @menu.cost = valid_cost
        expect(@menu).to be_valid
      end
    end
  end


  describe "when course_type_id is not present" do
    before { @menu.course_type_id = nil }
    it { should_not be_valid }
  end

  describe "when currency_type_id is not present" do
    before { @menu.currency_type_id = nil }
    it { should_not be_valid }
  end

  describe "when currency_type is different (on same date)" do

    before do
      @menu_with_other_currency = @menu.dup
      @menu_with_other_currency.name+="1" #other name
      @menu_with_other_currency.currency_type = FactoryBot.create(:currency_type, name: "Other currency type")
      @menu_with_other_currency.cost = @menu_with_other_currency.cost.to_s #scientific notation do not pass format validation
      @menu_with_other_currency.save!
    end

    it { should_not be_valid }

    describe "must be valid when currency type is same" do
      before { @menu.currency_type = @menu_with_other_currency.currency_type }
      
      it { should be_valid }
    end

  end


  describe "when menu_date is not today" do
    it "should be invalid" do
      menu_dates = [] << Date.yesterday << Date.tomorrow << 100.years.ago << 20.years.from_now 

      menu_dates.each do |invalid_date|
        @menu.menu_date = invalid_date
        expect(@menu).not_to be_valid
      end
    end
  end



end
