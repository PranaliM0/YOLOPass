class RegistrationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :event, serializer: SimpleEventSerializer
end
