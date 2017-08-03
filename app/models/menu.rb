class Menu < ApplicationRecord
  belongs_to :course_type,inverse_of: :menus
  belongs_to :currency_type,inverse_of: :menus
  has_many :orders,inverse_of: :menu, dependent: :restrict_with_exception
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :cost, presence: true
end
