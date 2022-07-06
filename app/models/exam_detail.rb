class ExamDetail < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  has_many :answers, through: :question
  accepts_nested_attributes_for :exam
end
