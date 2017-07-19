class AddIndexToCourseTypesName < ActiveRecord::Migration[5.1]
  def change
    add_index :course_types, :name, unique: true
  end
end
