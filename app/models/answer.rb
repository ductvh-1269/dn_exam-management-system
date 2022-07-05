class Answer < ApplicationRecord
  belongs_to :question
  enum is_correct: {false_answer: 0, true_answer: 1}, _default: 0
  validates :content, presence: true,
            length: {maximum: Settings.answer.content.max_1000}
end
