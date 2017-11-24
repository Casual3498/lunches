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
      pp CourseType.all
      pp @course_type
      pp course_type_with_same_name
      course_type_with_same_name.save
    end

    it { should_not be_valid }
  end


  describe "Course type must have name with 'first course', 'main course', 'drink' values" do
    course_types = [] << 'first course' << 'main course' << 'drink'
    course_types.each do |course_type|
      it { expect(CourseType.where('lower(name) = ?', course_type)).to exist }
    end
  end


  describe "unable to delete course type if used in menu" do

    let! (:menu_item) { FactoryBot.create(:menu) }

    it "should not destroy course type" do
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
