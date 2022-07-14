FactoryBot.define do
  factory :answer do
    association :question
    content {Faker::Company.name}
  end
end
