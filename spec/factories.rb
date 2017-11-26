FactoryBot.define do
  
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:password) { |n| "#{n.to_s*6}"}
    sequence(:password_confirmation) { |n| "#{n.to_s*6}"}
  
    factory :wrong_user do
      name     "Wrong Tester"
      email    "wrong@example.com"
      password "wrong_password"
      password_confirmation "wrong_password"
    end
  end

  factory :course_type do
    name   "Example course"
  end

  factory :currency_type do
    name   "Example currency"
  end  

  factory :menu do
    name "Example menu item"
    cost "99.98"
    menu_date Date.today
    course_type
    currency_type CurrencyType.first

    factory :menu_fc do
      sequence (:name) { |n| "#{Rails.configuration.valid_course_type_values.map(&:downcase).first} menu item#{n}" }
      cost "178.06"
      menu_date Date.today
      course_type CourseType.where('lower(name) = ?', Rails.configuration.valid_course_type_values.map(&:downcase).first).first
      currency_type CurrencyType.first
    end
    factory :menu_mc do
      sequence (:name) { |n| "#{Rails.configuration.valid_course_type_values.map(&:downcase).second} menu item#{n}" }
      cost "201.45"
      menu_date Date.today
      course_type CourseType.where('lower(name) = ?', Rails.configuration.valid_course_type_values.map(&:downcase).second).first
      currency_type CurrencyType.first
    end
    factory :menu_dr do
      sequence (:name) { |n| "#{Rails.configuration.valid_course_type_values.map(&:downcase).third} menu item#{n}" }
      cost "43.21"
      menu_date Date.today
      course_type CourseType.where('lower(name) = ?', Rails.configuration.valid_course_type_values.map(&:downcase).third).first
      currency_type CurrencyType.first
    end

  end

end