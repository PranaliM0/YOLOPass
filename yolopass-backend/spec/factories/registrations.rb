FactoryBot.define do
  factory :registration do
    association :user
    association :event
    payment_method { "upi" }
    payment_status { "pending" } # Will be set to 'pending' by callback'
    number_of_participants { 1 }
    discount_code { nil }  # Optional association

    after(:build) do |registration|
      registration.calculate_amount_paid
    end

    after(:create) do |registration|
      registration.create_payment!(
        amount: registration.amount_paid,
        status: 'pending',
        payment_method: registration.payment_method
      ) unless registration.payment
    end
  end
end
