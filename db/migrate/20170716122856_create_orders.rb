class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :users, index: true, null: false
      t.belongs_to :menus, index: true, null: false
      t.belongs_to :course_types, index: true, null: false
      t.timestamps
    end
  end
end
