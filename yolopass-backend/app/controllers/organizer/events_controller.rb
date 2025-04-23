class Organizer::EventsController < ApplicationController
  before_action :authenticate_user  # Ensure user is authenticated

  # POST /organizer/events
  def create
    # Initialize event with permitted parameters
    @event = Event.new(event_params)

    # Associate the event with the currently authenticated user
    @event.user_id = @current_user.id

    if @event.save
      # Return the created event with a success message
      render json: @event, status: :created
    else
      # Return errors if event creation fails
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /organizer/events
  def index
    # Fetch all events created by the currently authenticated user (organizer)
    @events = Event.where(user_id: @current_user.id)

    # Return the events in the response
    render json: @events
  end

  # GET /organizer/events/:id
  def show
    @event = Event.find(params[:id])

    render json: @event
  end

  # PATCH/PUT /organizer/events/:id
  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /organizer/events/:id
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      head :no_content
    else
      render json: { errors: 'Event deletion failed' }, status: :unprocessable_entity
    end
  end

  private

  # Only permit the event attributes
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
      :id_proof_required
    )
  end
end
