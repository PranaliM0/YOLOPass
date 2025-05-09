FactoryBot.define do
  factory :participant do
    association :registration

    name { "John Doe" }
    email { "john.doe@example.com" }
    phone { "1234567890" }
    id_proof_type { "Aadhar Card" }

    after(:build) do |participant|
      participant.uploaded_id.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'dummy_id.png')),
        filename: 'dummy_id.png',
        content_type: 'image/png'
      )
    end
  end
end
