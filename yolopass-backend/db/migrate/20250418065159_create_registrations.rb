class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :number_of_participants
      t.references :discount_code, null: false, foreign_key: true
      t.decimal :amount_paid ,precision: 10, scale: 2
      t.string :payment_method
      t.string :payment_status,null: false
      t.datetime :registered_at

      t.timestamps
    end
  end
end
