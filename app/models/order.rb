class OrderDateValidator < ActiveModel::Validator
  def validate(record)

    if record.order_date != Date.today
      record.errors[:base] << "You can create order only for today (\'#{Date.today}\') not for \'#{record.order_date}\' "

    end
  end
end

class Order < ApplicationRecord
  belongs_to :course_type,inverse_of: :orders
  belongs_to :user
  belongs_to :menu
  validates :menu_id, presence: true
  validates :user_id, presence: true
  validates :order_date, presence: true
  validates :course_type_id, presence: true, uniqueness: { scope: [:user_id,:order_date],
                                                                        message: "should used once per date" } 
  validates_with OrderDateValidator, fields: [:order_date]
end
