# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  # POST /login
  def create
    # Find user by email
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      # If authentication is successful, generate a JWT token
      token = encode_token({ user_id: @user.id })
      # Include the user's role in the response
      render json: { message: I18n.t('sessions.login_success'), token: token, role: @user.role },
             status: :ok
             
    else
      # Log the failed attempt for debugging
      Rails.logger.warn("Failed login attempt for #{params[:email]}")
      render json: { message: I18n.t('sessions.invalid_credentials') }, status: :unauthorized
    end
  end

  private

  # Method to generate JWT token with expiration
  def encode_token(payload)
    payload[:exp] = 1.hour.from_now.to_i # Set token to expire in 1 hour
    JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end
end
