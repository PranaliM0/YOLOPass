class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: I18n.t('application.access_denied') }, status: :forbidden
  end

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
      unless @current_user
        render json: { message: I18n.t('application.auth.unauthorized') }, status: :unauthorized
      end
    else
      render json: { message: I18n.t('application.auth.unauthorized') }, status: :unauthorized
    end
  end

  def authorize_admin
    authenticate_user and return if performed?

    unless @current_user&.admin?
      render json: { error: I18n.t('application.auth.unauthorized') }, status: :unauthorized
    end
  rescue => e
    render json: { error: I18n.t('application.auth.invalid_token') }, status: :unauthorized
  end

  def authorize_attendee
    authenticate_user and return if performed?

    unless @current_user&.attendee?
      render json: { error: I18n.t('application.auth.unauthorized') }, status: :unauthorized
    end
  rescue => e
    render json: { error: I18n.t('application.auth.invalid_token') }, status: :unauthorized
  end

  private

  def decode_token(token)
    begin
      decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end