
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

#NB after change this file alter sequence for tables in .travis.yml
#  - psql -d travis_ci_test -c 'ALTER SEQUENCE course_types_id_seq RESTART WITH 4;' 
#  - psql -d travis_ci_test -c 'ALTER SEQUENCE currency_types_id_seq RESTART WITH 4;'
