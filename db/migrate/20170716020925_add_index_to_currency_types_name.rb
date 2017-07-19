class AddIndexToCurrencyTypesName < ActiveRecord::Migration[5.1]
  def change
    add_index :currency_types, :name, unique: true
  end
end
