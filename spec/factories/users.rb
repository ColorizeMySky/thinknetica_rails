FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user do
    email
    password { "Dfghjd%6sgJHjh&" }
    password_confirmation { "Dfghjd%6sgJHjh&" }
  end
end
