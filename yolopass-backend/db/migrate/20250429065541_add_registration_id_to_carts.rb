class AddRegistrationIdToCarts < ActiveRecord::Migration[7.1]
  def change
    add_reference :registration_carts, :registration, null: false, foreign_key: true
  end
end
