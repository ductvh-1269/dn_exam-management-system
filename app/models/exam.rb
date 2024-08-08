class Exam < ApplicationRecord
  attr_accessor :exam_details_attributes

  belongs_to :user
  has_many :exam_details, dependent: :destroy
  has_many :questions, through: :exam_details
  accepts_nested_attributes_for :exam_details
end
