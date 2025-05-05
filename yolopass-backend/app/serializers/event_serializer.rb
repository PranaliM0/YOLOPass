class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :venue, :category, :start_time, :status
  
  has_many :registrations, serializer: RegistrationWithUserSerializer
  belongs_to :organizer, serializer: OrganizerSerializer
  
end
