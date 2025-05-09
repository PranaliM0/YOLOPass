# frozen_string_literal: true

class RegistrationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :event, serializer: SimpleEventSerializer
  belongs_to :discount_code, serializer: DiscountCodeSerializer
end

