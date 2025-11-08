FactoryBot.define do
  factory :vote do
    user
    association :votable, factory: :question
    value { 1 }

    trait :down do
      value { -1 }
    end

    trait :for_answer do
      association :votable, factory: :answer
    end
  end
end
