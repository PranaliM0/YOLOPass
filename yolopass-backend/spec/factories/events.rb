FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "Sample Event #{n}" }
    sequence(:venue) { |n| "Hall #{n}" }
    start_time { Faker::Time.forward(days: 5, period: :morning) }
    end_time { start_time + 2.hours }
    category { :tech }
    status { :open }
    price { 1000 }
    early_bird_discount { 20 }
    early_bird_deadline { 1.day.from_now }

    association :organizer, factory: :user  # Correct association

    trait :with_organizer do
      association :organizer, factory: :user
    end
  end
end
