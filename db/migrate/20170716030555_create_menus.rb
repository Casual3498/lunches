class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name, limit: 50, null: false
      t.decimal :cost, precision: 10, scale: 2
      t.belongs_to :course_types, index: true, null: false
      t.belongs_to :currency_types, index: true, null: false

      t.timestamps
    end
  end
end
