namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    #User.delete_all
    User.create!(name:  "Mr. First",
                 email: "first@lunches.md",
                 password:              "111111",
                 password_confirmation: "111111")
    User.create!(name:  "Mr. Second",
                 email: "second@lunches.md",
                 password:              "222222",
                 password_confirmation: "222222")
    User.create!(name:  "Mrs. Third",
                 email: "third@lunches.md",
                 password:              "333333",
                 password_confirmation: "333333")


    User.create!(name: "Example User",
                 email: "example@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end