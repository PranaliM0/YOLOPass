# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :venue
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status
      t.integer :category
      t.string :subcategory
      t.decimal :price
      t.decimal :early_bird_price
      t.datetime :early_bird_deadline
      t.integer :max_participants
      t.boolean :id_proof_required
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
