FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :attendee }

    trait :admin do
      role { :admin }
    end

    trait :organizer do
      role { :organizer }
    end
  end
end
