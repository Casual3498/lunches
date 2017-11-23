
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


