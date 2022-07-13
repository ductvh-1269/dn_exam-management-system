FactoryBot.define do
  factory :exam_detail do
    exam
    question {FactoryBot.create :question}
  end
end
