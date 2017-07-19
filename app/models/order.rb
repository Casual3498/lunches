class Order < ApplicationRecord
   belongs_to :course_type,inverse_of: :orders, readonly: true
end
