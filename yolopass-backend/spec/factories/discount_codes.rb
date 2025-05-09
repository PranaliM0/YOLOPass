# spec/factories/discount_codes.rb
FactoryBot.define do
  factory :discount_code do
    code { "DISCOUNT10" }
    discount_type { "percentage" }
    amount { 10.0 }
    expires_at { 1.day.from_now }
    max_uses { 5 }
    times_used { 0 }
    association :event
  end
end
