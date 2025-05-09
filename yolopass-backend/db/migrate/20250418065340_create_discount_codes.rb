# frozen_string_literal: true

class CreateDiscountCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :discount_codes do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :discount_type
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :expires_at
      t.integer :max_uses
      t.integer :times_used, default: 0

      t.timestamps
    end
  end
end
