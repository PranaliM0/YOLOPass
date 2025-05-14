module AuthenticationHelpers
  # Generate a valid JWT token for a user
  def generate_jwt(user)
    payload = { user_id: user.id } # Match the payload structure in ApplicationController
    secret_key = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key
    JWT.encode(payload, secret_key, 'HS256')
  end

  # Sign in a user and set the Authorization header
  def sign_in_user(user)
    # Assign the necessary role to the user (default is admin for tests)
    user.update!(role: 'admin') unless user.role == 'admin'

    # Generate a valid JWT token
    token = generate_jwt(user)

    # Set the Authorization header for the request
    request.headers['Authorization'] = "Bearer #{token}"
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
end