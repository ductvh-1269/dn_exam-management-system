class Subject < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions
  enum status: {inactive: 0, active: 1}
end
