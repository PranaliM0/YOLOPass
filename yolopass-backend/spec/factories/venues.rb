FactoryBot.define do
  factory :venue do
    name { "Test Venue" }
    location { "123 Test St, Test City" }
    capacity { 100 }
    description { "A test venue for events" }
  end
end