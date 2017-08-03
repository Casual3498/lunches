class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :menu, index: true, null: false
      t.belongs_to :course_type, index: true, null: false
      t.timestamps
    end
  end
end
