class AddIndexesForDate < ActiveRecord::Migration[5.1]
  def change
    add_index :menus, :menu_date, unique: false
    add_index :orders, :order_date, unique: false
  end
end
