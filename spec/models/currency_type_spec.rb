require 'rails_helper'

RSpec.describe CurrencyType, type: :model do
 before { @currency_type = CurrencyType.new(name: "Example currency") }

  subject { @currency_type }

  it { should respond_to(:name) }
  it { should respond_to(:menus) }

  describe "when name is not present" do
    before { @currency_type.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @currency_type.name = "a" * 21 }
    it { should_not be_valid }
  end

  describe "name must be unique" do
    before do
      currency_type_with_same_name = @currency_type.dup
      currency_type_with_same_name.name = @currency_type.name.upcase
      currency_type_with_same_name.save
    end

    it { should_not be_valid }
  end


  describe "currency type must have value" do
    it { expect(CurrencyType.first).to be_present }
  end

  describe "unable to delete currency type if used in menu" do

    let! (:menu_item) { FactoryBot.create(:menu) }

    it "should not destroy currency type" do
      currency_type = CurrencyType.find_by_id(menu_item.currency_type_id)
      currency_type_id = currency_type.id

      expect do
        currency_type.destroy
      end.to raise_error(ActiveRecord::DeleteRestrictionError)

      expect(CurrencyType.where(id: currency_type_id)).not_to be_empty

      menu_item.destroy
      currency_type.destroy

      expect(CurrencyType.where(id: currency_type_id)).to be_empty
    end
  end

end