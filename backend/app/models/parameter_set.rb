class ParameterSet < ApplicationRecord
  belongs_to :question_template
  has_many :questions, dependent: :destroy

  validates :parameters, presence: true
end
