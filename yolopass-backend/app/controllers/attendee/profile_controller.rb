# frozen_string_literal: true

module Attendee
  class ProfileController < ApplicationController
    #load_and_authorize_resource class: 'User' 

    def show
      authorize! :read, @current_user
      user = @current_user

      # Safely build event list from registrations
      registered_events = user.registrations.includes(:event).map do |registration|
        event = registration.event
        next unless event # skip if event is nil (data integrity)

        {
          registration_id: registration.id,
          event_id: event.id,
          event_name: event.name,
          event_venue: event.venue,
          event_start_time: event.start_time
        }
      end.compact # remove nils if any

      render json: {
        profile: {
          name: user.name,
          email: user.email
        },
        registered_events: registered_events
      }
    end
  end
end
