FactoryBot.define do
  factory :answer do
    body { "Test Answer Body" }
    association :question

    trait :invalid do
      body { nil }
    end
  end
end
