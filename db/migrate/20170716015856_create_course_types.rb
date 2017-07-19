class CreateCourseTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :course_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
