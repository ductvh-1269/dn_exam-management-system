FactoryBot.define do
  factory :user do
    first_name {Faker::Name.name}
    last_name {Faker::Name.name}
    email {Faker::Internet.email}
    role {:admin}
    password {"admin123123"}
  end
end
