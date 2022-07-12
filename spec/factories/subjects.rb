FactoryBot.define do
  factory :subject do
    user
    status {:active}
    name {Faker::Book.title}
    content {Faker::Lorem.paragraph}
  end
end
