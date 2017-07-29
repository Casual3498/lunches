class CurrencyType < ApplicationRecord
  has_many :menus, inverse_of: :currency_type, dependent: :restrict_with_exception
  validates :name, presence: true, length: {maximum: 20}, uniqueness: {case_sensitive: false}
end
