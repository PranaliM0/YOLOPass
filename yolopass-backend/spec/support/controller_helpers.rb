# spec/support/controller_helpers.rb

module ControllerHelpers
  def sign_in_user(user)
    token = JsonWebToken.encode(user_id: user.id)  # Assuming this method is implemented
    request.headers['Authorization'] = "Bearer #{token}"
  end
end
