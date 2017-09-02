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
      record.errors[:base] << "You can add\\edit menu item only for today (\"#{Date.today}\" ) not for \"#{record.menu_date}\" "
    end
  end
end


class Menu < ApplicationRecord
  mount_uploader :picture, PictureUploader
  belongs_to :course_type,inverse_of: :menus
  belongs_to :currency_type,inverse_of: :menus
  has_many :orders, dependent: :restrict_with_exception
  validates :name, presence: true, length: {maximum: 50}, uniqueness: { scope: [:menu_date,:course_type_id],
                                                                        message: "should used once per course type" }
  validates :cost,  presence: true, 
                    format: { :with => /\A\d{0,8}(\.\d{0,2})?\z/ },
                    numericality: {:greater_than_or_equal => 0, :less_than_or_equal => 99999999.99}
  validates_with CurrencyValidator, fields: [:currency_type_id, :menu_date]
  validates_with DateValidator, fields: [:menu_date]

end


