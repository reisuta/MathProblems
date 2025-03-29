class MathTopic < ApplicationRecord
  has_many :question_templates, dependent: :destroy
  validates :name, presence: true
  validates :grade, presence: true
  validates :subject, presence: true
end
