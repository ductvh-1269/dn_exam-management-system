FactoryBot.define do
  factory :answer do
    question
    content {Faker::Company.name}
  end
end
