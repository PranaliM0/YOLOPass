class Admin::DashboardController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin
  
  def stats
    render json: {
      total_users: User.count,
      total_events: Event.count,
      total_organizers: User.organizer.count
    }
  end
end
