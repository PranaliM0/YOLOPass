FactoryBot.define do
  factory :participant do
    name { "John Doe" }
    email { "john@example.com" }
    phone { "1234567890" }
    id_proof_type { "Aadhar" }

    registration  

    uploaded_id do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/support/assets/sample.png"),
        "image/png"
      )
    end
  end
end
