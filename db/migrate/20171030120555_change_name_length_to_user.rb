class ChangeNameLengthToUser < ActiveRecord::Migration[5.1]
  def up
    change_column :currency_types, :name, :string, limit: 50, null: false
  end
  def down
    change_column :currency_types, :name, :string, limit: 20, null: false
  end  
end
