class User < ApplicationRecord
  acts_as_token_authenticatable
  has_many :orders, inverse_of: :user, dependent: :restrict_with_exception
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: {maximum: 50}

  #first registered user is lunches admin 
  before_save { self.lunches_admin = true if User.count == 0 }
  before_destroy { User.second.update!(lunches_admin: true) if !User.second.nil? } #not working if type User.first.delete in console

end