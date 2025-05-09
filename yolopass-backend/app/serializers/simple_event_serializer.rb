# frozen_string_literal: true

class SimpleEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :venue, :start_time
end
