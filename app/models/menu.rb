class Menu < ApplicationRecord
  belongs_to :course_type,inverse_of: :menus
  belongs_to :currency_type,inverse_of: :menus
  has_many :orders, dependent: :restrict_with_exception
  validates :name, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false}
  validates :cost, presence: true, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal => 0, :less_than_or_equal => 10}
end
