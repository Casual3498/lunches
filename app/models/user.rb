class User < ApplicationRecord
  acts_as_token_authenticatable
  has_many :orders, inverse_of: :user, dependent: :restrict_with_exception
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #validates :name, presence: true

  def is_lunches_admin?
    self == User.first
  end



end
