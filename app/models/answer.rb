class Answer < ApplicationRecord
  belongs_to :question
  delegate :name, to: :subject
end
