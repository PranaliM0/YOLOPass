class Admin::DashboardController < ApplicationController
  before_action :authorize_admin

  def stats
    render json: {
      total_users: User.count,
      total_events: Event.count,
      total_organizers: User.organizer.count
    }
  end

  private

  def authorize_admin
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded =decode_token(token)
    @current_user = User.find(decoded[:user_id]) if decoded

    unless @current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue
    render json: { error: 'Invalid token or not authorized' }, status: :unauthorized
  end
end
