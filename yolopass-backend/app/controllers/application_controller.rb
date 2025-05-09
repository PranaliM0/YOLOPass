class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: I18n.t('application.access_denied') }, status: :forbidden
  end

  before_action :authenticate_user

  def current_user
    @current_user
  end
  

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
      render json: { message: I18n.t('application.auth.unauthorized') }, status: :unauthorized unless @current_user
    else
      render json: { message: I18n.t('application.auth.unauthorized') }, status: :unauthorized
    end
  end

  def decode_token(token)
    decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
