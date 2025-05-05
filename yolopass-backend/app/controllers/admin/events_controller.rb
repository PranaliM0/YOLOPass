class Admin::EventsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin

  # GET /admin/events
  def index
    events = Event.includes(:organizer).all
    render json: events, each_serializer: EventSerializer, status: :ok
  end
  
  # DELETE /admin/events/:id
  def destroy
    event = Event.find_by(id: params[:id])
    if event
      event.destroy
      render json: { message: t('admin.events.destroy.success') }, status: :ok
    else
      render json: { error: t('admin.events.destroy.not_found') }, status: :not_found
    end
  end
end
