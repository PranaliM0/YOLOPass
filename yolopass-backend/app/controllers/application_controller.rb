class ApplicationController < ActionController::API
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

