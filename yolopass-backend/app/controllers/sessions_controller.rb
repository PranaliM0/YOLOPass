class SessionsController < ApplicationController
  # POST /login
  def create
    # Find user by email
    @user = User.find_by(email: params[:email])

    # Check if user exists and password is correct
    if @user && @user.authenticate(params[:password])
      # If authentication is successful, generate a JWT token
      token = encode_token({ user_id: @user.id })

      # Include the user's role in the response
      render json: { message: 'Login successful', token: token, role: @user.role }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  # Method to generate JWT token with expiration
  def encode_token(payload)
    payload[:exp] = 1.hour.from_now.to_i  # Set token to expire in 1 hour
    JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end
end
