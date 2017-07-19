class CurrencyType < ApplicationRecord
  has_many :menus, inverse_of: :currency_type, dependent: :restrict_with_exception
end
