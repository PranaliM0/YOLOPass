# frozen_string_literal: true

class ProfileSerializer < ActiveModel::Serializer
  attributes :name, :email
  has_many :registrations, key: :registered_events, serializer: RegistrationWithEventSerializer
end
