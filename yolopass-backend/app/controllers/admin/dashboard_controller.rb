# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    load_and_authorize_resource

    def stats
      render json: {
        total_users: User.count,
        total_events: Event.count,
        total_organizers: User.organizer.count
      }
    end
  end
end
