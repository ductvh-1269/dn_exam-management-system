FactoryBot.define do
  factory :question do
    subject
    status {:active}
    question_type {:single_select}
    content {Faker::Lorem.question}
  end
end
