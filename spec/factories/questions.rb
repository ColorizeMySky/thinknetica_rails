FactoryBot.define do
  factory :question do
    title { "Test Question Title" }
    body { "Test Question Body" }
    association :user

    trait :invalid do
      title { nil }
    end
  end
end
