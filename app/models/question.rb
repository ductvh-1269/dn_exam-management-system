class Question < ApplicationRecord
  belongs_to :subject
  has_many :answers, dependent: :destroy
  has_many :history_details, dependent: :destroy
  has_many :histories, through: :history_details
  belongs_to :subject
  enum question_type: {single_select: 0, multiple_select: 1,
                       essay_question: 2}
end
