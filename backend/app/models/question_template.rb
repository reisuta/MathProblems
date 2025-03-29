class QuestionTemplate < ApplicationRecord
  belongs_to :math_topic
  has_many :parameter_sets, dependent: :destroy
  has_many :questions, dependent: :destroy

  enum difficulty: { beginner: 0, intermediate: 1, advanced: 2 }

  validates :title, presence: true
  validates :question_formula, presence: true
  validates :solution_steps, presence: true
end
