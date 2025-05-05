class Organizer::VenuesController < ApplicationController
  before_action :authenticate_user
  def index
    venues = Venue.all.select(:id, :name, :capacity)
    render json: venues
  end
  def available
    start_time = params[:start_time]
    end_time = params[:end_time]

    if start_time.blank? || end_time.blank?
      return render json: { error: t('organizer.venues.available.time_required') }, status: :bad_request
    end

    # Find venues that are occupied during the requested time
    booked_venues = Event.where("start_time < ? AND end_time > ?", end_time, start_time).pluck(:venue)

    # Assuming you have a Venue model with all possible venues
    available_venues = Venue.where.not(name: booked_venues)

    render json: available_venues
  end
end
