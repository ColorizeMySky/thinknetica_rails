FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user do
    email
    password { "password" }
    password_confirmation { "password" }
  end
end
