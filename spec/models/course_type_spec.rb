require 'rails_helper'

RSpec.describe CourseType, type: :model do
  before { @course_type = CourseType.new(name: "Example course type") }

  subject { @course_type }

  it { should respond_to(:name) }
  it { should respond_to(:menus) }
  it { should respond_to(:orders) }

  describe "when name is not present" do
    before { @course_type.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @course_type.name = "a" * 21 }
    it { should_not be_valid }
  end

  describe "name must be unique" do
    before do
      course_type_with_same_name = @course_type.dup
      course_type_with_same_name.name = @course_type.name.upcase
      course_type_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "settings parameter 'valid_course_type_values' must be array of String" do
    course_types = Rails.configuration.valid_course_type_values

    #usually don't reached because other specs crashed before with 'error occurred outside of examples'

    it { expect(course_types.is_a?(Array)).to be_truthy } 

    course_types.each do |course_type|
      it { expect(course_type.is_a?(String)).to be_truthy }
    end
  end



  describe "Course type must have name with 'first course', 'main course', 'drink' values and only these" do
    course_types = Rails.configuration.valid_course_type_values.map(&:downcase)
    course_types.each do |course_type|
      it { expect(CourseType.where('lower(name) = ?', course_type)).to exist }
    end

    it { expect(CourseType.count).to equal(course_types.count)}
  end


  describe "unable to delete course type if used in menu" do

    let! (:menu_item) { FactoryBot.create(:menu) }


    it "should not destroy course type if used and destroy if not" do

      course_type = CourseType.find_by_id(menu_item.course_type_id)
      course_type_id = course_type.id

      expect do
        course_type.destroy
      end.to raise_error(ActiveRecord::DeleteRestrictionError)

      expect(CourseType.where(id: course_type_id)).not_to be_empty

      menu_item.destroy
      course_type.destroy

      expect(CourseType.where(id: course_type_id)).to be_empty
    end
  end





end
