class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name, limit: 50, null: false
      t.decimal :cost, precision: 10, scale: 2, null: false
      t.belongs_to :course_type, index: true, null: false
      t.belongs_to :currency_type, index: true, null: false

      t.timestamps
    end
  end
end
