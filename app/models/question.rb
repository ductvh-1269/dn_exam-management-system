class Question < ApplicationRecord
  belongs_to :subject
  has_many :answers, dependent: :destroy
  has_many :history_details, dependent: :destroy
  has_many :histories, through: :history_details
end
