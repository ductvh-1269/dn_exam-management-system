FactoryBot.define do
  factory :exam do
    subject {FactoryBot.create :subject}
    user {FactoryBot.create :user}
  end
end
