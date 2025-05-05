class Organizer::EventsController < ApplicationController
  include Rails.application.routes.url_helpers

  before_action :authenticate_user  # Ensure user is authenticated
  #before_action :authorize_organizer
  before_action :set_event, only: [:show, :update, :destroy]

  # POST /organizer/events
  def create
    @event = Event.new(event_params)
    @event.user_id = @current_user.id

    if @event.save
      render json: event_data(@event), status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def event_details
    @event = Event.find_by(id: params[:id])
    
    if @event
      render json: @event
    else
      render json: { error: t('organizer.events.event_details.not_found') }, status: :not_found
    end
  end

  # GET /organizer/events
  def index
    @events = Event.where(user_id: @current_user.id)
    render json: @events.map { |event| event_data(event) }
  end

  # GET /organizer/events/:id
  def show
    render json: event_data(@event)
  end

  # PATCH/PUT /organizer/events/:id
  def update
    if @event.update(event_params)
      render json: event_data(@event)
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /organizer/events/:id
  def destroy
    if @event.destroy
      head :no_content
    else
      render json: { errors: t('organizer.events.destroy.not_deleted') }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name,
      :description,
      :venue,
      :start_time,
      :end_time,
      :category,
      :subcategory,
      :price,
      :early_bird_discount,
      :early_bird_deadline,
      :max_participants,
      :id_proof_required,
      :image
    )
  end

  def event_data(event)
    event.as_json.merge({
      image_url: event.image.attached? ? url_for(event.image) : nil
    })
  end
end
