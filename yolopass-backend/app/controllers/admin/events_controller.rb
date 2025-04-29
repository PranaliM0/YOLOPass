class Admin::EventsController < ApplicationController
  before_action :authenticate_user
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
          id: event.organizer.id,
          name: event.organizer.name,
          email: event.organizer.email
        }
      }
    }, status: :ok
  end

  # DELETE /admin/events/:id
  def destroy
    event = Event.find_by(id: params[:id])
    if event
      event.destroy
      render json: { message: "Event deleted successfully" }, status: :ok
    else
      render json: { error: "Event not found" }, status: :not_found
    end
  end
end
