# frozen_string_literal: true

class Venue < ApplicationRecord
  validates :name, presence: true
  validates :location, presence: true
  validates :capacity, numericality: { only_integer: true }, presence: true
  validates :description, presence: true
  has_many :events
end
