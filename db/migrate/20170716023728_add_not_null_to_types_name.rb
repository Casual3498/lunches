class AddNotNullToTypesName < ActiveRecord::Migration[5.1]
  def change
    change_column :currency_types, :name, :string, limit: 20, null: false
    change_column :course_types, :name, :string, limit: 20, null: false  
  end
end
