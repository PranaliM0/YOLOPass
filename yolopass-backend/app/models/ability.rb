# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    case user.role
    when 'admin'
      can :manage, :all
      can :manage, DiscountCode

    when 'organizer'
      can :profile, Attendee::ProfileController, user_id: user.id
      can :create, Event # Allow organizers to create events
      can :update, Event, user_id: user.id # Allow organizers to update their own events
      can :destroy, Event, user_id: user.id # Allow organizers to destroy their own events
      can :read, Event, user_id: user.id # Allow organizers to view their own events
      can :event_details, Event, user_id: user.id

      # Allow organizers to manage discount codes related to their events
      can :read, DiscountCode do |discount_code|
        discount_code.event.user_id == user.id
      end
      can :create, DiscountCode, event: { user_id: user.id }
      can :update, DiscountCode, event: { user_id: user.id }
      can :destroy, DiscountCode, event: { user_id: user.id }
      
    when 'attendee'
       # Attendees can only see events that are open
       can :events_grouped_by_category, :attendees 
       can :read, Event, status: 'open' # Allow attendees to read only open events
       can :show, Attendee::EventsController
       can :manage, :attendee_events
       # Attendees can read and edit their own profile
       can :read, User, id: user.id # Allow attendees to view and edit their own profile
       can :read, Attendee
       # Attendees can create registrations and read their own registration
       can :create, Registration
       can :read, Registration, user_id: user.id
       
       # Attendees can view discount codes for open events
       can :read, DiscountCode do |discount_code|
        event = discount_code.event
        event.present? &&
          (
            event.status == 'open' ||
            (event.start_date <= Time.current && event.end_date >= Time.current)
          )
       end
    end
  end
end
