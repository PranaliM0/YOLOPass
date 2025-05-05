class SimpleEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :venue, :start_time
end
