User.delete_all
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

CurrencyType.delete_all
CurrencyType.create!(id: "1",
                     name: "RUB")
CurrencyType.create!(id: "2",
                     name: "UAH")
CurrencyType.create!(id: "3",
                     name: "USD")

CourseType.delete_all
CourseType.create!(id: "1",
                   name: "first course")
CourseType.create!(id: "2",
                   name: "main course")
CourseType.create!(id: "3",
                   name: "drink")


