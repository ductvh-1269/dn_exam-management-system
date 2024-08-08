class ExamDetail < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  accepts_nested_attributes_for :exam
end
