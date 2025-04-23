class Admin::EventsController < ApplicationController
  before_action :authorize_admin

  # GET /admin/events
  def index
    events = Event.includes(:organizer).all
    render json: events.map { |event|
      {
        id: event.id,
        name: event.name,
        venue: event.venue,
        category: event.category,
        start_time: event.start_time,
        status: event.status,
        organizer: {
          id: event.organizer.user.id,
          name: event.organizer.user.name,
          email: event.organizer.user.email
        }
      }
    }
  end

  # DELETE /admin/events/:id
  def destroy
    event = Event.find(params[:id])
    event.destroy
    render json: { message: "Event deleted successfully" }
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
end
