class Attendee::AttendeesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_attendee

  # Group events by category and return structured data
  def events_grouped_by_category
    # Get all open events
    events = Event.where(status: :open)

    # Return a message if no events are available
    if events.empty?
      render json: { message: 'No open events available at the moment.' }, status: :not_found
      return
    end

    # Group events by category and make category names human-readable
    grouped_events = events
                        .group_by(&:category)
                        .transform_keys { |key| key.to_s.humanize.capitalize }

    # Add event image URLs to the events
    grouped_events = grouped_events.map do |category, events_list|
      events_list = events_list.map { |event| event_data_with_image(event) }
      [category, events_list]
    end.to_h

    render json: grouped_events
  end

  # Return profile and registered events data for the attendee
  def profile
    attendee = @current_user
    registered_events = attendee.registrations.includes(:event).map do |registration|
      event = registration.event
      event_data_with_image(event)
    end

    # Return profile and registered events data
    render json: {
      profile: {
        name: attendee.name,
        email: attendee.email,
        phone: attendee.phone
      },
      registeredEvents: registered_events.presence || { message: 'No registered events found.' }
    }
  end

  private

  # Helper method to format event data with image URL
  def event_data_with_image(event)
    event.as_json.merge({
      image_url: event.image.attached? ? url_for(event.image) : nil
    })
  end
end
