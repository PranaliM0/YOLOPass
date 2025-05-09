# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :number_of_participants
      t.references :discount_code, null: true, foreign_key: true # Allow null for discount_code
      t.decimal :amount_paid, precision: 10, scale: 2
      t.string :payment_method
      t.string :payment_status, null: false, default: 'pending'  # Default to 'pending'
      t.datetime :registered_at
      t.references :payment, null: true, foreign_key: true # Add reference to Payment (optional at first)

      t.timestamps
    end
  end
end
