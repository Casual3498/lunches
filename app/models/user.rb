class User < ApplicationRecord
  has_many :orders, inverse_of: :user, dependent: :restrict_with_exception
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_lunches_admin?
    self == User.first
  end



end
