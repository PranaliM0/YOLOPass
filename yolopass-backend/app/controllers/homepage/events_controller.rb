# frozen_string_literal: true

module Homepage
  class EventsController < ApplicationController
    include Rails.application.routes.url_helpers
    skip_before_action :authenticate_user, only: [:featured]

    def featured
      events = Event.order('RANDOM()').limit(4)

      featured_events = events.map do |event|
        event.as_json.merge(
          image_url: event.image.attached? ? url_for(event.image) : nil
        )
      end

      render json: featured_events, status: :ok
    end
  end
end
