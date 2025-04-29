class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: 'Access Denied' }, status: :forbidden
  end

  # Method to decode the token and authenticate the user
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)
  
    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end
  #authorize admin
  def authorize_admin
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
  
    if decoded && decoded[:user_id]
      @current_user = User.find_by(id: decoded[:user_id])
    end
  
    unless @current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue => e
    render json: { error: 'Invalid token or not authorized' }, status: :unauthorized
  end
  

  #authorize attendee
  def authorize_attendee
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
  
    if decoded && decoded[:user_id]
      @current_user = User.find_by(id: decoded[:user_id])
    end
  
    unless @current_user&.attendee?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue => e
    render json: { error: 'Invalid token or not authorized' }, status: :unauthorized
  end
  
  #authorize user
  # def authorize_organizer
  #   header = request.headers['Authorization']
  #   token = header.split(' ').last if header
  #   decoded =decode_token(token)
  #   @current_user = User.find_by(decoded[:user_id]) if decoded

  #   unless @current_user.organizer
  #     render json: { error: 'Unauthorized' }, status: :unauthorized
  #   end
  # rescue
  #   render json: { error: 'Invalid token or not authorized' }, status: :unauthorized
  # end

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

