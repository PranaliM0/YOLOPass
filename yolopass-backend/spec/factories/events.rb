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
    user 
    #association :organizer, factory: :user
    trait :with_organizer do
      association :user, factory: :organizer # If you have a specific factory for organizer
    end
  end
end
