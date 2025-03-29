class Question < ApplicationRecord
  belongs_to :question_template
  belongs_to :parameter_set
  has_many :user_answers, dependent: :destroy
  has_many :users, through: :user_answers

  validates :content, presence: true
  validates :answer, presence: true
end
