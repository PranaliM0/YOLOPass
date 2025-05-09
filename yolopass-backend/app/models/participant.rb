# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :registration
  has_one_attached :uploaded_id

  validates :name, :email, :phone, :id_proof_type, presence: true
end
