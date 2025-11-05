FactoryBot.define do
  factory :reward do
    title { 'Best answer reward' }
    association :question
    user { nil }
  end
end
