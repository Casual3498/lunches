class CurrencyValidator < ActiveModel::Validator
  def validate(record)
    menus = Menu.all.where("menu_date='#{record.menu_date}' ")
    if menus.first 
      if menus.any?{|menu| record.send(:currency_type_id) != menus.first.currency_type_id}
        record.errors[:base] << "Other currency (#{CurrencyType.find_by_id(menus.first.currency_type_id).name}) already used in Menu on #{record.menu_date} ! You entered (#{CurrencyType.find_by_id(record.currency_type_id).name}) "
      end
    end
  end
end

class DateValidator < ActiveModel::Validator
  def validate(record)
    if record.menu_date != Date.today
      record.errors[:base] << "You can add/edit menu item only for today (\'#{Date.today}\' ) not for \'#{record.menu_date}\' "
    end
  end
end

class OrderExistsValidator < ActiveModel::Validator
  def validate(record)
    if Order.find_by menu_id: record.id
      record.errors[:base] << "You can not change the name/cost of menu item because there is an order that includes this item."
    end
  end
end


class Menu < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :course_type,inverse_of: :menus
  belongs_to :currency_type,inverse_of: :menus
  has_many :orders, dependent: :restrict_with_exception
  validates :name, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false, 
                                                                      scope: [:menu_date,:course_type_id],
                                                                      message: "should used once per course type" 
                                                                    }
                                                                      
  validates :cost,  presence: true
  #numericality: {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999.99}
  #validates_format_of :cost, :with => /(\A(\d{1,8}(\.\d{0,2})?)\z)|(\A\.\d{1,2}\z)/
  validate :cost_format
  COST_REGEXP = /(\A(\d{1,8}(\.\d{0,2})?)\z)|(\A\.\d{1,2}\z)/

  validates_with CurrencyValidator, fields: [:currency_type_id, :menu_date]
  validates_with DateValidator, fields: [:menu_date]
  validates_with OrderExistsValidator, fields: [:name, :cost]

  private
  def cost_format
    unless read_attribute_before_type_cast('cost') =~ COST_REGEXP
      errors.add('cost', 'must be a positive number not greater 99999999.99 with period (dot) as decimal separator and not more than 2 digits after decimal point.')
    end
  end

end
