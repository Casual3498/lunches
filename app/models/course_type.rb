class CourseType < ApplicationRecord
  has_many :menus, inverse_of: :course_type, dependent: :restrict_with_exception
  has_many :orders, inverse_of: :course_type, dependent: :restrict_with_exception
end
