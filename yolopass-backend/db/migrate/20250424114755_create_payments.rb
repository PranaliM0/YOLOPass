class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :registration, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.string :transaction_id

      t.timestamps
    end
  end
end
