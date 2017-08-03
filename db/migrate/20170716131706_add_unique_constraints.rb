class AddUniqueConstraints < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_date, :date, null: false 
    add_index :orders, [:user_id, :course_type_id, :menu_id, :order_date], unique: true, name: 'course_type_uq'
  
    add_column :menus, :menu_date, :date, null: false
    add_index :menus, [:name, :course_type_id, :menu_date], unique: true, name: 'name_uq'
  end
end
