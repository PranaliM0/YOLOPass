class Admin::UsersController < ApplicationController
  before_action :authorize_admin

  def index
    users = User.all
    render json: users
  end

  #cannot delete admin
  def destroy
    user = User.find(params[:id])
  
    if user.admin?
      render json: { error: 'Cannot delete an admin' }, status: :unprocessable_entity
    else
      user.destroy
      render json: { message: 'User deleted successfully' }
    end
  end
  

  private

  def authorize_admin
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
    @current_user = User.find(decoded[:user_id]) if decoded

    unless @current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue
    render json: { error: 'Invalid token or not authorized' }, status: :unauthorized
  end

  def organizers
    organizers = User.where(role: 'organizer').includes(organizer: :events)
  
    render json: organizers.map { |user|
      {
        id: user.id,
        name: user.name,
        email: user.email,
        events: user.organizer&.events&.map do |event|
          {
            id: event.id,
            name: event.name,
            venue: event.venue,
            category: event.category,
            start_time: event.start_time,
            status: event.status
          }
        end
      }
    }
  end  
end
