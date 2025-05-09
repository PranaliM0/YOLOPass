# frozen_string_literal: true

class EventWithImageSerializer < ActiveModel::Serializer
  attributes :id, :name, :venue, :category, :price, :start_time, :status, :image_url

  def image_url
    object.image.attached? ? Rails.application.routes.url_helpers.url_for(object.image) : nil
  end
end
