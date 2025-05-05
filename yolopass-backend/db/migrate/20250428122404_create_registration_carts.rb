class CreateRegistrationCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :registration_carts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :number_of_participants, null: false, default: 1
      t.decimal :amount_paid, precision: 10, scale: 2
      t.string :payment_method
      t.string :payment_status, default: 'pending'
      t.references :registration, null: false, foreign_key: true
      t.timestamps
    end
  end
end
