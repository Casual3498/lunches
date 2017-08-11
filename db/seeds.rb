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

Menu.delete_all
Menu.create!(name: "борщ", cost: "110", menu_date: "2017-08-01", course_type_id: 1, currency_type_id: 1)
Menu.create!(name: "котлетки с пюрешкой", cost: "150", menu_date: "2017-08-01", course_type_id: 2, currency_type_id: 1)
Menu.create!(name: "кипяток", cost: "0", menu_date: "2017-08-01", course_type_id: 3, currency_type_id: 1)

Menu.create!(name: "o'baby", cost: "111", menu_date: "2017-08-11", course_type_id: 1, currency_type_id: 1)
Menu.create!(name: "banana soup", cost: "111", menu_date: "2017-08-11", course_type_id: 1, currency_type_id: 1)
Menu.create!(name: "котлетки с макарошками", cost: "130", menu_date: "2017-08-11", course_type_id: 2, currency_type_id: 1)
Menu.create!(name: "курица с гречкой", cost: "138.56", menu_date: "2017-08-11", course_type_id: 2, currency_type_id: 1)
Menu.create!(name: "квас", cost: "50", menu_date: "2017-08-11", course_type_id: 3, currency_type_id: 1)
Menu.create!(name: "pineapple juice", cost: "70", menu_date: "2017-08-11", course_type_id: 3, currency_type_id: 1)
