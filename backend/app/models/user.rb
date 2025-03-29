class User < ApplicationRecord
  has_secure_password
  has_many :user_answers, dependent: :destroy
  has_many :questions, through: :user_answers

  enum role: { student: 0, teacher: 1, admin: 2 }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
