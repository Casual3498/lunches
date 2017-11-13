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

end