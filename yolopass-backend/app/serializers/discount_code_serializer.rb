class DiscountCodeSerializer < ActiveModel::Serializer
  attributes :code, :discount_percentage
end
