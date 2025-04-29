class Admin::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin

  def index
    users = User.all
    render json: users
  end
 
  # GET /admin/event_registrations
  def event_registrations
    events = Event.includes(:registrations => :user).map do |event|
      {
        id: event.id,
        name: event.name,
        users: event.registrations.map do |registration|
          {
            id: registration.user.id,
            name: registration.user.name,
            email: registration.user.email
          }
        end
      }
    end

    render json: events
  end

   # GET /admin/unregistered_users
   def unregistered_users
    registered_user_ids = Registration.select(:user_id).distinct.pluck(:user_id)

    users = User.where(role: 'attendee') # Assuming role = 'attendee'
                .where.not(id: registered_user_ids)

    render json: users.select(:id, :name, :email)
  end

  #cannot delete admin
  def destroy
    user = User.find(params[:id])
  
    if user.admin?
      render json: { error: 'Cannot delete an admin' }, status: :unprocessable_entity
    else
      user.destroy
      render json: { message: 'User deleted successfully' }
    end
  end
  

  private

  def organizers
    organizers = User.where(role: 'organizer').includes(organizer: :events)
  
    render json: organizers.map { |user|
      {
        id: user.id,
        name: user.name,
        email: user.email,
        events: user.organizer&.events&.map do |event|
          {
            id: event.id,
            name: event.name,
            venue: event.venue,
            category: event.category,
            start_time: event.start_time,
            status: event.status
          }
        end
      }
    }
  end  
end
