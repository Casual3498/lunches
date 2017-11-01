class AddNotNullToTypesName < ActiveRecord::Migration[5.1]
  def up
    change_column :currency_types, :name, :string, limit: 20, null: false
    change_column :course_types, :name, :string, limit: 20, null: false  
  end
  def down
    change_column :currency_types, :name, :string, limit: nil, null: true
    change_column :course_types, :name, :string, limit: nil, null: true  
  end

end
