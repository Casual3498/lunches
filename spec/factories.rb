
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
    menu_date Date.current
    course_type
    currency_type CurrencyType.first


    factory :menu_fc do
      course_type1 =  if Rails.configuration.valid_course_type_values.is_a?(Array)  
                        CourseType.where('lower(name) = ?',
                          Rails.configuration.valid_course_type_values.map(&:downcase).first).first
                      else 
                        CourseType.first
                      end
      sequence (:name) { |n| "#{course_type1.name} menu item#{n}" }
      cost Faker::Number.unique.decimal(8, 2)
      course_type course_type1

      factory :menu_fc_skips_validate do
        to_create {|instance| instance.save(validate: false) }
      end
    end

    factory :menu_mc do
      course_type2 =  if Rails.configuration.valid_course_type_values.is_a?(Array) 
                        CourseType.where('lower(name) = ?',
                          Rails.configuration.valid_course_type_values.map(&:downcase).second).first
                      else 
                        CourseType.second
                      end   
      sequence (:name) { |n| "#{course_type2.name} menu item#{n}" }
      cost Faker::Number.decimal(8, 2)
      course_type course_type2
      factory :menu_mc_skips_validate do
        to_create {|instance| instance.save(validate: false) }
      end      
    end

    factory :menu_dr do
      course_type3 =  if Rails.configuration.valid_course_type_values.is_a?(Array) 
                        CourseType.where('lower(name) = ?',
                          Rails.configuration.valid_course_type_values.map(&:downcase).third).first
                      else
                        CourseType.third
                      end     
      sequence (:name) { |n| "#{course_type3.name} menu item#{n}" }
      cost Faker::Number.decimal(8, 2)
      course_type course_type3
      factory :menu_dr_skips_validate do
        to_create {|instance| instance.save(validate: false) }
      end
    end

  end

  factory :order do
    order_date Date.current
    menu
    course_type
    user
    factory :order_skips_validate do
      to_create {|instance| instance.save(validate: false) }
    end    
  end

end