class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.references :registration, null: false, foreign_key: true
      t.string :receipt_number
      t.datetime :payment_date
      t.decimal :amount
      t.integer :payment_method
      t.string :transaction_id
      t.datetime :generated_at

      t.timestamps
    end
  end
end
