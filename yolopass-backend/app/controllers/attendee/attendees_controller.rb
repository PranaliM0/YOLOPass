# frozen_string_literal: true

module Attendee
  class AttendeesController < ApplicationController
    # Group events by category and return structured data
    def events_grouped_by_category
      authorize! :events_grouped_by_category, :attendees
      # Get all open events
      events = Event.where(status: :open)

      # Return a message if no events are available
      if events.empty?
        render json: { message: I18n.t('attendee.attendees.events_grouped_by_category.event_not_found') },
               status: :not_found
        return
      end

      # Group events by category, make category names human-readable, and add event images
      grouped_events = events
                       .group_by(&:category)
                       .transform_keys { |key| key.to_s.humanize.capitalize }
                       .transform_values do |events_list|
                         ActiveModelSerializers::SerializableResource.new(events_list,
                                                                          each_serializer: EventWithImageSerializer)
                       end

      render json: grouped_events
    end

    # Return profile and registered events data for the attendee
    def profile
      attendee = @current_user
      registered_events = attendee.registrations.includes(:event).map(&:event)
      render json: {
        profile: {
          name: attendee.name,
          email: attendee.email,
          phone: attendee.phone
        },
        registeredEvents: ActiveModelSerializers::SerializableResource.new(registered_events,
                                                                           each_serializer: EventWithImageSerializer)
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
end
