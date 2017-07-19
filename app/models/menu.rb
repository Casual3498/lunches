class Menu < ApplicationRecord
  belongs_to :course_type,inverse_of: :menus, readonly: true
  belongs_to :currency_type,inverse_of: :menus, readonly: true
  has_many :orders,inverse_of: :menu, dependent: :restrict_with_exception
end
