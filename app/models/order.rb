class OrderDateValidator < ActiveModel::Validator
  def validate(record)
    if record.order_date != Date.current
      record.errors[:base] << "You can create order only for today (\'#{Date.current}\') not for \'#{record.order_date}\' "
    else #order_date == Date.current
      if record.menu && (record.menu.menu_date != Date.current)
        record.errors[:base] << "You can add in order only menu item from today menu (\'#{Date.current}\') not from menu at \'#{record.menu.menu_date}\' "
      end
    end
  end
end

class CourseTypeEqualValidator < ActiveModel::Validator
  def validate(record)
    if record.menu && (record.course_type_id != record.menu.course_type_id)
      record.errors[:base] << "Internal error. Course type in order not equal course type in menu."
    end
  end
end

class CourseTypeNameValidator < ActiveModel::Validator
  def validate(record)
    course_types = Rails.configuration.valid_course_type_values.map(&:downcase)
    if record.course_type  && 
      !course_types.empty? && #don't check if empty
      !course_types.include?(record.course_type.name.downcase) 
      
      record.errors[:base] << "Course type in order must be only: '#{course_types.join("','")}'" 
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
  validates_with CourseTypeEqualValidator, fields: [:course_type_id,:menu_id]
  validates_with CourseTypeNameValidator, fields: [:course_type_id]  
end
