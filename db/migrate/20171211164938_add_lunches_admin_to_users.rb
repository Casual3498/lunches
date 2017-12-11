class AddLunchesAdminToUsers < ActiveRecord::Migration[5.1]
  def change

    add_column :users, :lunches_admin, :boolean, default: false, null: false

  end
end
