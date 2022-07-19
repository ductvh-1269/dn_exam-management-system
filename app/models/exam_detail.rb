class ExamDetail < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  belongs_to :answer, class_name: "Answer", foreign_key: :selected_answer_id,
optional: true
  has_many :answers, through: :question
  accepts_nested_attributes_for :exam
end
