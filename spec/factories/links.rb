FactoryBot.define do
  factory :link do
    name { 'MyLink' }
    url { 'https://example.com' }
    association :linkable, factory: :question

    trait :gist do
      url { 'https://gist.github.com/ColorizeMySky/007acb1d9ff16655821bdbf2e7f5dcb3.js' }
    end

    trait :invalid do
      name { nil }
      url { 'invalid-url' }
    end
  end
end
