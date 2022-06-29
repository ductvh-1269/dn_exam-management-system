class History < ApplicationRecord
  belongs_to :user
  has_many :history_details, dependent: :destroy
  has_many :questions, through: :history_details
end
