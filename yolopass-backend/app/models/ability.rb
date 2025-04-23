class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    if user.role == 'admin'
      can :manage, :all
    elsif user.role == 'organizer'
      can :create, Event  # Allow organizers to create events
      can :update, Event, user_id: user.id  # Allow organizers to update their own events
      can :destroy, Event, user_id: user.id  # Allow organizers to destroy their own events
      can :read, Event, user_id: user.id  # Allow organizers to view their own events
    elsif user.role == 'attendee'
      can :read, Event, status: 'open'  # Allow attendees to read only open events
    end
  end
end
