class Exam < ApplicationRecord
  belongs_to :user
  has_many :exam_details, dependent: :destroy
  has_many :questions, through: :exam_details
  accepts_nested_attributes_for :exam_details
end
